require "rails_helper"

RSpec.describe Activity, type: :model do
  describe "#finance" do
    it "always returns Standard Grant, code '110'" do
      activity = Activity.new
      expect(activity.finance).to eq "110"
    end
  end

  describe "#tied_status" do
    it "always returns Untied, code '5'" do
      activity = Activity.new
      expect(activity.tied_status).to eq "5"
    end
  end

  describe "scopes" do
    describe ".funds" do
      it "only returns fund level activities" do
        fund_activity = create(:fund_activity)
        other_activiy = create(:programme_activity)

        expect(Activity.funds).to include(fund_activity)
        expect(Activity.funds).not_to include(other_activiy)
      end
    end

    describe ".programmes" do
      it "only returns programme level activities" do
        programme_activity = create(:programme_activity)
        other_activiy = create(:fund_activity)

        expect(Activity.programmes).to include(programme_activity)
        expect(Activity.programmes).not_to include(other_activiy)
      end
    end

    describe ".publishable_to_iati?" do
      it "only returns activities with a `form_state` of :complete and/or `publish_to_iati` of true" do
        complete_activity = create(:fund_activity)
        _incomplete_activity = create(:fund_activity, :at_purpose_step)
        _complete_redacted_activity = create(:fund_activity, publish_to_iati: false)
        _incomplete_redacted_activity = create(:fund_activity, :at_identifier_step, publish_to_iati: false)

        expect(Activity.publishable_to_iati).to eq [complete_activity]
      end
    end
  end

  describe "sanitisation" do
    it { should strip_attribute(:identifier) }
  end

  describe "validations" do
    context "overall activity state" do
      context "when the activity form is a draft" do
        subject { build(:activity, :at_identifier_step, form_state: "blank") }
        it { should be_valid }
      end

      context "when the activity form is final" do
        subject { build(:activity, :at_identifier_step, form_state: "complete") }
        it { should be_invalid }
      end
    end

    context "when the level is blank" do
      subject(:activity) { build(:activity, level: nil) }
      it "should not be valid" do
        expect(activity.valid?(:level_step)).to be_falsey
      end
    end

    context "when the parent is blank" do
      context "when the activity is a fund" do
        subject(:activity) { build(:activity, :level_form_state, level: :fund) }
        it "should be valid" do
          expect(activity.valid?(:parent_step)).to be_truthy
        end
      end

      context "when the activity is not a fund" do
        subject(:activity) { build(:activity, :blank_form_state) }
        it "should not be valid" do
          expect(activity.valid?(:parent_step)).to be_falsey
        end
      end
    end

    context "when identifier is blank" do
      subject(:activity) { build(:activity, identifier: nil) }
      it "should not be valid" do
        expect(activity.valid?(:identifier_step)).to be_falsey
      end
    end

    describe "#identifier" do
      context "when an activity exists with the same identifier" do
        context "shares the same parent" do
          it "should be invalid" do
            fund = create(:fund_activity)
            create(:programme_activity, identifier: "GB-GOV-13-001", parent: fund)

            new_programme_activity = build(:programme_activity, identifier: "GB-GOV-13-001", parent: fund)

            expect(new_programme_activity).not_to be_valid
          end
        end

        context "does NOT share the same parent" do
          it "should be valid" do
            create(:fund_activity) do |fund|
              create(:programme_activity, identifier: "GB-GOV-13-001", parent: fund)
            end

            other_fund = create(:fund_activity)
            new_programme_activity = build(:programme_activity, identifier: "GB-GOV-13-001", parent: other_fund)

            expect(new_programme_activity).to be_valid
          end
        end
      end
    end

    context "when title is blank" do
      subject(:activity) { build(:activity, title: nil) }
      it "should not be valid" do
        expect(activity.valid?(:purpose_step)).to be_falsey
      end
    end

    context "when description is blank" do
      subject(:activity) { build(:activity, description: nil) }
      it "should not be valid" do
        expect(activity.valid?(:purpose_step)).to be_falsey
      end
    end

    context "when sector category is blank" do
      subject(:activity) { build(:activity, sector_category: nil) }
      it "should not be valid" do
        expect(activity.valid?(:sector_category_step)).to be_falsey
      end
    end

    context "when sector is blank" do
      subject(:activity) { build(:activity, sector: nil) }
      it "should not be valid" do
        expect(activity.valid?(:sector_step)).to be_falsey
      end
    end

    context "when planned start and actual start dates are blank" do
      subject(:activity) { build(:activity, planned_start_date: nil, actual_start_date: nil) }
      it "should not be valid" do
        expect(activity.valid?(:dates_step)).to be_falsey
      end
    end

    context "when programme status is blank" do
      subject(:activity) { build(:activity, programme_status: nil) }
      it "should not be valid" do
        expect(activity.valid?(:programme_status_step)).to be_falsey
      end
    end

    context "when planned_start_date is blank but actual_start_date is not nil" do
      subject(:activity) { build(:activity, planned_start_date: nil) }
      it "should be valid" do
        expect(activity.valid?(:dates_step)).to be_truthy
      end
    end

    context "when actual_start_date is blank but planned_start_date is not nil" do
      subject(:activity) { build(:activity, actual_start_date: nil) }
      it "should be valid" do
        expect(activity.valid?(:dates_step)).to be_truthy
      end
    end

    context "when planned_end_date is blank" do
      subject(:activity) { build(:activity, planned_end_date: nil) }
      it "should be valid" do
        expect(activity.valid?(:dates_step)).to be_truthy
      end
    end

    context "when actual_start_date is blank" do
      subject(:activity) { build(:activity, actual_start_date: nil) }
      it "should be valid" do
        expect(activity.valid?(:dates_step)).to be_truthy
      end
    end

    context "when actual_end_date is blank" do
      subject(:activity) { build(:activity, actual_end_date: nil) }
      it "should be valid" do
        expect(activity.valid?(:dates_step)).to be_truthy
      end
    end

    context "when planned_start_date is not blank" do
      let(:activity) { build(:activity) }

      it "does not allow a planned_start_date more than 10 years ago" do
        activity = build(:activity, planned_start_date: 11.years.ago)
        expect(activity.valid?).to be_falsey
        expect(activity.errors[:planned_start_date]).to include "Date must be between 10 years ago and 25 years in the future"
      end

      it "does not allow a planned_start_date more than 25 years in the future" do
        activity = build(:activity, planned_start_date: 26.years.from_now)
        expect(activity.valid?).to be_falsey
      end

      it "allows a planned_start_date between 10 years ago and 25 years in the future" do
        activity = build(:activity, planned_start_date: Date.today)
        expect(activity.valid?).to be_truthy
      end
    end

    context "when the actual_start_date is not blank" do
      it "allows todays date" do
        activity = build(:activity, actual_start_date: Date.today)
        expect(activity.valid?).to be_truthy
      end

      it "allows dates in the past" do
        activity = build(:activity, actual_start_date: 1.year.ago)
        expect(activity.valid?).to be_truthy
      end

      it "does not allow a date in the future" do
        activity = build(:activity, actual_start_date: 1.day.from_now)
        expect(activity.valid?).to be_falsey
      end
    end

    context "when the actual_end_date is not blank" do
      it "allows todays date" do
        activity = build(:activity, actual_end_date: Date.today)
        expect(activity.valid?).to be_truthy
      end

      it "allows dates in the past" do
        activity = build(:activity, actual_end_date: 1.year.ago)
        expect(activity.valid?).to be_truthy
      end

      it "does not allow a date in the future" do
        activity = build(:activity, actual_end_date: 1.day.from_now)
        expect(activity.valid?).to be_falsey
      end
    end

    context "when geography is blank" do
      subject(:activity) { build(:activity, geography: nil) }
      it "should not be valid" do
        expect(activity.valid?(:geography_step)).to be_falsey
      end
    end

    context "when geography is recipient_region" do
      context "and recipient_region and recipient_contry are blank" do
        subject { build(:activity) }
        it { should validate_presence_of(:recipient_region).on(:region_step) }
        it { should_not validate_presence_of(:recipient_country).on(:country_step) }
      end
    end

    context "when geography is recipient_country" do
      context "and recipient_region and recipient_country are blank" do
        subject { build(:activity, geography: :recipient_country) }
        it { should validate_presence_of(:recipient_country).on(:country_step) }
        it { should_not validate_presence_of(:recipient_region).on(:region_step) }
      end
    end

    context "when flow is blank" do
      subject(:activity) { build(:activity, flow: nil) }
      it "should not be valid" do
        expect(activity.valid?(:flow_step)).to be_falsey
      end
    end

    context "when saving in the update_extending_organisation context" do
      subject { build(:activity) }
      it { should validate_presence_of(:extending_organisation_id).on(:update_extending_organisation) }
    end

    context "when the form state is blank" do
      it "allows updates to be made to other fields set on creation" do
        blank_activity = create(:activity, funding_organisation_name: "old", form_state: :blank)
        blank_activity.funding_organisation_name = "new"
        expect(blank_activity.valid?).to eq(true)
      end
    end
  end

  describe "associations" do
    it { should belong_to(:organisation) }
    it { should belong_to(:parent).optional }
    it { should have_many(:child_activities).with_foreign_key("parent_id") }
    it { should belong_to(:extending_organisation).with_foreign_key("extending_organisation_id").optional }
    it { should have_many(:implementing_organisations) }
    it { should belong_to(:reporting_organisation).with_foreign_key("reporting_organisation_id") }
    it { should have_many(:budgets) }
    it { should have_many(:transactions) }
    it { should have_many(:planned_disbursements) }
  end

  describe "#parent_activities" do
    context "when the activity is a fund" do
      it "returns an empty array" do
        result = build(:fund_activity).parent_activities
        expect(result).to eq([])
      end
    end

    context "when the activity is a programme" do
      it "returns the fund" do
        programme = create(:programme_activity)
        fund = programme.parent

        result = programme.parent_activities
        expect(result.first.id).to eq(fund.id)
      end
    end

    context "when the activity is a project" do
      it "returns the fund and then the programme" do
        project = create(:project_activity)
        programme = project.parent
        fund = programme.parent

        result = project.parent_activities

        expect(result.first.id).to eq(fund.id)
        expect(result.second.id).to eq(programme.id)
      end
    end

    context "when the activity is a third party project" do
      it "returns the fund and then the programme and then the project" do
        third_party_project = create(:third_party_project_activity)
        project = third_party_project.parent
        programme = project.parent
        fund = programme.parent

        result = third_party_project.parent_activities

        expect(result.first.id).to eq(fund.id)
        expect(result.second.id).to eq(programme.id)
        expect(result.third.id).to eq(project.id)
      end
    end
  end

  describe "#associated_fund" do
    context "when the activity is a fund" do
      it "returns itself" do
        fund = create(:fund_activity)
        expect(fund.associated_fund).to eq(fund)
      end
    end

    context "when the activity is a programme" do
      it "returns the parent fund" do
        programme = create(:programme_activity)
        fund = programme.parent

        expect(programme.associated_fund).to eq(fund)
      end
    end

    context "when the activity is a project" do
      it "returns the ancestor fund" do
        project = create(:project_activity)
        programme = project.parent
        fund = programme.parent

        expect(project.associated_fund).to eq(fund)
      end
    end

    context "when the activity is a third party project" do
      it "returns the ancestor fund" do
        third_party_project = create(:third_party_project_activity)
        project = third_party_project.parent
        programme = project.parent
        fund = programme.parent

        expect(third_party_project.associated_fund).to eq(fund)
      end
    end
  end

  describe "#form_stpes_completed?" do
    it "is true when a user has completed all of the form steps" do
      activity = build(:activity, form_state: :complete)

      expect(activity.form_steps_completed?).to be_truthy
    end

    it "is false when a user is still completing one of the form steps" do
      activity = build(:activity, form_state: :purpose)

      expect(activity.form_steps_completed?).to be_falsey
    end

    it "is false when the form_stat is nil " do
      activity = build(:activity, form_state: nil)

      expect(activity.form_steps_completed?).to be_falsey
    end
  end

  describe "#has_funding_organisation?" do
    it "returns true if all funding_organisation fields are present" do
      activity = build(:fund_activity)

      expect(activity.has_funding_organisation?).to be true
    end

    it "returns false if all funding_organisation fields are not present" do
      activity = build(:activity)

      expect(activity.has_funding_organisation?).to be false
    end
  end

  describe "#has_accountable_organisation?" do
    it "returns true if all accountable_organisation fields are present" do
      activity = build(:fund_activity)

      expect(activity.has_accountable_organisation?).to be true
    end
  end

  it "returns false if all accountable_organisation fields are not present" do
    activity = build(:activity)

    expect(activity.has_accountable_organisation?).to be false
  end

  describe "#has_extending_organisation?" do
    it "returns true if all extending_organisation fields are present" do
      activity = build(:fund_activity)

      expect(activity.has_extending_organisation?).to be true
    end
  end

  it "returns false if all extending_organisation fields are not present" do
    activity = build(:activity)

    expect(activity.has_extending_organisation?).to be false
  end

  describe "#has_implementing_organisation?" do
    it "returns true when there is one or more implementing organisationg" do
      activity = create(:project_activity_with_implementing_organisations)

      expect(activity.has_implementing_organisations?).to be true
    end
  end

  describe "#providing_organisation" do
    context "when the activity is a fund or a programme" do
      it "returns BEIS" do
        beis = create(:beis_organisation)
        fund = build(:fund_activity)
        expect(fund.providing_organisation).to eql beis

        programme = build(:programme_activity)
        expect(programme.providing_organisation).to eql beis
      end
    end

    context "when the activity is a project" do
      context "when the activity organisation is a government type" do
        it "returns BEIS" do
          beis = create(:beis_organisation)
          government_delivery_partner = build(:delivery_partner_organisation, organisation_type: "10")

          project = build(:project_activity, organisation: government_delivery_partner)
          expect(project.providing_organisation).to eql beis
        end
      end

      context "when the activity organisation is a non-government type" do
        it "returns BEIS" do
          beis = create(:beis_organisation)
          non_government_delivery_partner = create(:delivery_partner_organisation, organisation_type: "22")

          project = build(:project_activity, organisation: non_government_delivery_partner)
          expect(project.providing_organisation).to eql beis
        end
      end
    end

    context "when the activity is a third-party project" do
      context "when the activity organisation is a government type" do
        it "returns BEIS" do
          beis = create(:beis_organisation)
          government_delivery_partner = build(:delivery_partner_organisation, organisation_type: "10")

          project = build(:project_activity, organisation: government_delivery_partner)
          expect(project.providing_organisation).to eql beis
        end
      end

      context "when the activity organisation is a non-government type" do
        it "returns the activity organisation i.e the delivery partner" do
          non_government_delivery_partner = create(:delivery_partner_organisation, organisation_type: "22")

          third_party_project = build(:third_party_project_activity, organisation: non_government_delivery_partner)
          expect(third_party_project.providing_organisation).to eql non_government_delivery_partner
        end
      end
    end
  end

  describe "#parent_level" do
    context "when the level is a fund" do
      it "returns nil" do
        result = described_class.new(level: :fund).parent_level
        expect(result).to eql(nil)
      end
    end

    context "when the level is a programme" do
      it "returns a string for fund" do
        result = described_class.new(level: :programme).parent_level
        expect(result).to eql("fund")
      end
    end

    context "when the level is a project" do
      it "returns a string for programme" do
        result = described_class.new(level: :project).parent_level
        expect(result).to eql("programme")
      end
    end

    context "when the level is a third-party project" do
      it "returns a string for project" do
        result = described_class.new(level: :third_party_project).parent_level
        expect(result).to eql("project")
      end
    end
  end

  describe "#child_level" do
    context "when the level is a fund" do
      it "returns a string for programme" do
        result = described_class.new(level: :fund).child_level
        expect(result).to eql("programme")
      end
    end

    context "when the level is a programme" do
      it "returns a string for project" do
        result = described_class.new(level: :programme).child_level
        expect(result).to eql("project")
      end
    end

    context "when the level is a project" do
      it "returns a string for a third-party project" do
        result = described_class.new(level: :project).child_level
        expect(result).to eql("third_party_project")
      end
    end

    context "when the level is a third-party project" do
      it "returns nil" do
        expect { described_class.new(level: :third_party_project).child_level }
          .to raise_error("no level below third_party_project")
      end
    end
  end

  describe "#iati_identifier" do
    context "when the activity is a fund" do
      it "returns a composite identifier formed with the reporting organisation" do
        fund = build(:fund_activity, identifier: "GCRF-1", reporting_organisation: create(:beis_organisation))
        expect(fund.iati_identifier).to eql("GB-GOV-13-GCRF-1")
      end
    end

    context "when the activity is a programme" do
      context "when the reporting organisation is a government organisation" do
        it "returns an identifier with the reporting organisation, fund and programme" do
          government_organisation = build(:organisation, iati_reference: "GB-GOV-13")
          programme = create(:programme_activity, organisation: government_organisation)
          fund = programme.parent

          expect(programme.iati_identifier)
            .to eql("GB-GOV-13-#{fund.identifier}-#{programme.identifier}")
        end
      end
    end

    context "when the activity is a project" do
      context "when the reporting organisation is a government organisation" do
        it "returns an identifier with the reporting organisation, fund, programme and project" do
          government_organisation = build(:organisation, iati_reference: "GB-GOV-13")
          project = create(:project_activity, organisation: government_organisation, reporting_organisation: government_organisation)
          programme = project.parent
          fund = programme.parent

          expect(project.iati_identifier)
            .to eql("GB-GOV-13-#{fund.identifier}-#{programme.identifier}-#{project.identifier}")
        end
      end
    end

    context "when the activity is a third-party project" do
      context "when the reporting organisation is a government organisation" do
        it "returns an identifier with the reporting organisation, fund, programme, project and third-party project" do
          government_organisation = build(:organisation, iati_reference: "GB-GOV-13")
          third_party_project = create(:third_party_project_activity, organisation: government_organisation, reporting_organisation: government_organisation)
          project = third_party_project.parent
          programme = project.parent
          fund = programme.parent

          expect(third_party_project.iati_identifier)
            .to eql("GB-GOV-13-#{fund.identifier}-#{programme.identifier}-#{project.identifier}-#{third_party_project.identifier}")
        end
      end
    end
  end

  describe "#transactions_total" do
    it "returns the total of all the activity's transactions" do
      project = create(:project_activity)
      create(:transaction, parent_activity: project, value: 100.20)
      create(:transaction, parent_activity: project, value: 210)

      expect(project.transactions_total).to eq(310.20)
    end
  end

  describe "#actual_total_for_report_financial_quarter" do
    it "returns the total of all the activity's transactions scoped to a report" do
      project = create(:project_activity, :with_report)
      report = Report.find_by(fund: project.associated_fund, organisation: project.organisation)
      create(:transaction, parent_activity: project, value: 100.20, report: report, date: Date.today)
      create(:transaction, parent_activity: project, value: 50.00, report: report, date: Date.today)
      create(:transaction, parent_activity: project, value: 210, report: report, date: Date.today - 4.months)

      expect(project.actual_total_for_report_financial_quarter(report: report)).to eq(150.20)
    end

    it "does not include the totals for any transactions outside the report's date range" do
      project = create(:project_activity, :with_report)
      report = Report.find_by(fund: project.associated_fund, organisation: project.organisation)
      create(:transaction, parent_activity: project, value: 100.20, report: report, date: Date.today - 6.months)
      create(:transaction, parent_activity: project, value: 210, report: report, date: Date.today - 4.months)

      expect(project.actual_total_for_report_financial_quarter(report: report)).to eq(0)
    end
  end

  describe "#actual_total_for_report_financial_quarter" do
    it "returns the total of all the activity's transactions scoped to a report" do
      project = create(:project_activity, :with_report)
      report = Report.find_by(fund: project.associated_fund, organisation: project.organisation)
      create(:transaction, parent_activity: project, value: 100.20, report: report, date: Date.today)
      create(:transaction, parent_activity: project, value: 210)

      expect(project.actual_total_for_report_financial_quarter(report: report)).to eq(100.20)
    end
  end
end
