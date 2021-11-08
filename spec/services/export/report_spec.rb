RSpec.describe Export::Report do
  before(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    @report = create(:report)

    @project = create(:project_activity_with_implementing_organisations)

    @implementing_organisation =
      ImplementingOrganisation.create(
        name: "The name of the organisation that implements the activity",
        reference: "IMP-002",
        organisation_type: "10"
      )

    @third_party_project =
      create(
        :third_party_project_activity,
        parent: @project,
        implementing_organisations: [@implementing_organisation]
      )

    @headers_for_report = Export::ActivityAttributesOrder.attributes_in_order.map { |att|
      I18n.t("activerecord.attributes.activity.#{att}")
    }
  end

  after(:all) do
    DatabaseCleaner.clean
  end

  context "when there are activities" do
    subject { described_class.new(report: @report) }

    before do
      relation = Activity.where(level: ["project", "third_party_project"])
      finder_double = double(Activity::ProjectsForReportFinder, call: relation)
      allow(Activity::ProjectsForReportFinder).to receive(:new).and_return(finder_double)
    end

    describe "#headers" do
      it "returns the headers" do
        headers = subject.headers

        expect(headers).to include(@headers_for_report.first)
        expect(headers).to include(@headers_for_report.last)
        expect(headers).to include("Implementing organisations")
      end
    end

    describe "#rows" do
      it "returns the rows ordered by level" do
        rows = subject.rows.to_a

        expect(rows.count).to eq 2

        first_row = rows.first
        expect(first_row.first).to eq(@project.roda_identifier)
        expect(first_row.last).to include(@project.implementing_organisations.first.name)

        last_row = rows.last
        expect(last_row.first).to include(@third_party_project.roda_identifier)
        expect(last_row.last).to include(@third_party_project.implementing_organisations.first.name)
      end
    end

    describe "row caching" do
      it "export rows method if only called once" do
        rows_data_double = double(Hash, fetch: [], empty?: false)

        attribute_double = double(rows: rows_data_double)
        allow(Export::ActivityAttributesColumns).to receive(:new).and_return(attribute_double)

        implementing_organisation_double = double(rows: rows_data_double)
        allow(Export::ActivityImplementingOrganisationColumn).to receive(:new).and_return(implementing_organisation_double)

        subject.rows

        expect(attribute_double)
          .to have_received(:rows)
          .once

        expect(implementing_organisation_double)
          .to have_received(:rows)
          .once
      end
    end
  end

  context "when there are no activities" do
    subject { described_class.new(report: @report) }

    before do
      relation = Activity.none
      finder_double = double(Activity::ProjectsForReportFinder, call: relation)
      allow(Activity::ProjectsForReportFinder).to receive(:new).and_return(finder_double)
    end

    describe "#headers" do
      it "returns the headers" do
        headers = subject.headers

        expect(headers).to include(@headers_for_report.first)
        expect(headers).to include(@headers_for_report.last)
        expect(headers).to include("Implementing organisations")
      end
    end

    describe "#rows" do
      it "returns no rows" do
        expect(subject.rows.count).to eq 0
      end
    end
  end
end
