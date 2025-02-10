RSpec.feature "BEIS users can view project activities as XML" do
  let(:user) { create(:beis_user) }
  let(:organisation) { create(:partner_organisation) }
  let(:activity) { create(:project_activity, organisation: organisation) }
  let(:xml) { Nokogiri::XML::Document.parse(page.body) }

  before { authenticate!(user: user) }

  after { logout }

  it "includes its parent activity in the related-activity field" do
    visit organisation_activity_path(organisation, activity, format: :xml)

    expect(xml.xpath("//iati-activity/related-activity").count).to eq(2)
    expect(xml.at("iati-activity/related-activity/@type").text).to eq("1")
  end

  context "when the activity has a previous activity identifier" do
    before do
      activity.update(
        partner_organisation_identifier: "ID-ENT-IFIER",
        previous_identifier: "PREV-ID-ENT-IFIER",
        transparency_identifier: "GB-GOV-13-ID-ENT-IFIER"
      )
    end

    it "shows the activity transparency identifier as the iati identifier" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.at("iati-activity/iati-identifier").text).to eq(activity.transparency_identifier)
    end

    it "shows the previous identifier as the other identifier" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.at("iati-activity/other-identifier/@ref").text).to eq(activity.previous_identifier)
    end
  end

  context "when the activity has one benefitting country" do
    before { activity.update(benefitting_countries: ["CV"]) }

    it "contains data about the recipient country" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.at("iati-activity/recipient-country/@code").text).to eq("CV")
      expect(xml.at("iati-activity/recipient-country/narrative").text).to eq("Cabo Verde")
      expect(xml.at("iati-activity/recipient-country/@percentage").text).to eq("100.0")
    end

    it "contains nothing about the benefitting region" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.at("iati-activity/recipient-region")).to be_nil
    end

    it "contains the IATI scope element" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.at("iati-activity/activity-scope/@code").text).to eql("4")
    end
  end

  context "when the activity has multiple benefitting countries in different regions" do
    before { activity.update(benefitting_countries: ["CV", "BZ"]) }

    it "merges the countries into the 998 region" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      result = xml.xpath("//iati-activity/recipient-region")[0]

      expect(result.at("@code").text).to eq("998")
      expect(result.at("@percentage").text).to eq("100.0")
      expect(result.at("narrative").text).to eq("Developing countries, unspecified")
    end

    it "contains the IATI scope element" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.at("iati-activity/activity-scope/@code").text).to eql("3")
    end
  end

  context "when the activity has multiple benefitting countries in the same region" do
    before { activity.update(benefitting_countries: ["CV", "BJ"]) }

    it "merges the countries into the correct region" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      result = xml.xpath("//iati-activity/recipient-region")[0]

      expect(result.at("@code").text).to eq("1030")
      expect(result.at("@percentage").text).to eq("100.0")
      expect(result.at("narrative").text).to eq("Western Africa, regional")
    end

    it "contains the IATI scope element" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.at("iati-activity/activity-scope/@code").text).to eql("2")
    end
  end

  context "when the activity has no benefitting countries" do
    let(:activity) { create(:project_activity, organisation: organisation, benefitting_countries: nil) }

    it "does not contain the IATI scope element" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.at("iati-activity/activity-scope")).to be_nil
    end
  end

  context "when the activity has a legacy recipient_region and no benefitting countries" do
    before { activity.update(recipient_region: "489") }

    it "contains the recipient region code and fixed vocabulary code of 1" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.at("iati-activity/recipient-region/@code").text).to eq(activity.recipient_region)
      expect(xml.at("iati-activity/recipient-region/@vocabulary").text).to eq("1")
    end

    it "contains the recipient region name as a narrative element" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.at("iati-activity/recipient-region/narrative").text).to eq("South America, regional")
    end
  end

  context "when the activity has a legacy recipient_region and at least one benefitting country" do
    before { activity.update(recipient_region: "489", benefitting_countries: ["CV"]) }

    it "contains appropriate data about the recipient region" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.at("iati-activity/recipient-country/@code").text).to eq(activity.benefitting_countries.first)
      expect(xml.at("iati-activity/recipient-region")).to be_nil
    end
  end

  context "when the activity does not have actual dates (optional dates)" do
    before { activity.update(actual_start_date: nil, actual_end_date: nil) }

    it "does not include empty optional dates" do
      visit organisation_activity_path(organisation, activity, format: :xml)
      optional_start_date = xml.at("iati-activity/activity-date[@type = '2']")
      optional_end_date = xml.at("iati-activity/activity-date[@type = '4']")

      expect(optional_start_date).to be_nil
      expect(optional_end_date).to be_nil
    end
  end

  context "when the activity has a collaboration_type" do
    before { activity.update(collaboration_type: "1") }

    it "contains the relevant collaboration_type code" do
      visit organisation_activity_path(organisation, activity, format: :xml)
      expect(xml.at("iati-activity/collaboration-type/@code").text).to eq "1"
    end
  end

  context "when the activity has policy markers" do
    before do
      activity.update(
        policy_marker_gender: "not_targeted",
        policy_marker_biodiversity: "significant_objective",
        policy_marker_disability: "principal_objective",
        policy_marker_desertification: "principal_objective_and_in_support_of_an_action_programme",
        policy_marker_nutrition: "not_assessed",
        policy_marker_climate_change_adaptation: "not_assessed",
        policy_marker_climate_change_mitigation: "not_assessed",
        policy_marker_disaster_risk_reduction: "not_assessed"
      )
    end

    it "includes all the policy markers with reportable values for IATI" do
      visit organisation_activity_path(organisation, activity, format: :xml)

      vocabulary_values = xml.xpath("//iati-activity/policy-marker/@vocabulary").to_a.map(&:value)
      expect(vocabulary_values).to match_array(["1", "1", "1", "1"])

      codes = xml.xpath("//iati-activity/policy-marker/@code").to_a.map(&:value)
      expect(codes).to match_array(["1", "11", "5", "8"])

      significances = xml.xpath("//iati-activity/policy-marker/@significance").to_a.map(&:value)
      expect(significances).to match_array(["0", "1", "2", "3"])
    end
  end

  context "when the activity is Covid19-related" do
    before { activity.update(covid19_related: "1") }

    it "appends 'COVID-19' to the activity description" do
      visit organisation_activity_path(organisation, activity, format: :xml)
      expect(xml.at("iati-activity/description/narrative").text).to end_with "COVID-19"
    end
  end

  context "when the activity's covid19_related field is nil" do
    before { activity.update_columns(covid19_related: nil) }

    it "does not throw an error" do
      visit organisation_activity_path(organisation, activity, format: :xml)
      expect(xml.at("iati-activity/description/narrative").text).to eql(activity.description)
    end
  end

  context "when the activity has implementing organisations" do
    let(:activity) { create(:project_activity_with_implementing_organisations, :with_transparency_identifier) }

    it_behaves_like "valid activity XML"
  end

  context "when the activity has budgets" do
    it "only includes budgets which belong to the activity" do
      _budget = create(:budget, parent_activity: activity)
      _other_budget = create(:budget)

      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.xpath("//iati-activity/budget").count).to eq(1)
    end

    context "when the activity's budgets have no revisions" do
      it "only includes budgets which belong to the activity" do
        _budget = create(:budget, parent_activity: activity)
        _other_budget = create(:budget)

        visit organisation_activity_path(organisation, activity, format: :xml)

        expect(xml.xpath("//iati-activity/budget").count).to eq(1)
      end

      it "has the correct budget XML" do
        _budget = create(:budget, parent_activity: activity)

        visit organisation_activity_path(organisation, activity, format: :xml)

        expect(xml.xpath("//iati-activity/budget/@type").text).to eq("1")
        expect(xml.xpath("//iati-activity/budget/@status").text).to eq("1")
        expect(xml.xpath("//iati-activity/budget/value").text).to eq("110.01")
      end
    end

    context "when the activity's budgets have been revised" do
      let!(:budget) { create(:budget, :with_revisions, parent_activity: activity) }
      let!(:other_budget) { create(:budget) }

      it "only includes budgets which belong to the activity" do
        visit organisation_activity_path(organisation, activity, format: :xml)

        expect(xml.xpath("//iati-activity/budget").count).to eq(2)
      end

      it "has the correct budget XML for the original and revised budget" do
        visit organisation_activity_path(organisation, activity, format: :xml)

        expect(xml.xpath("//iati-activity/budget[1]/@type").text).to eq("1")
        expect(xml.xpath("//iati-activity/budget[1]/@status").text).to eq("1")
        expect(xml.xpath("//iati-activity/budget[1]/value").text).to eq("110.01")

        expect(xml.xpath("//iati-activity/budget[2]/@type").text).to eq("2")
        expect(xml.xpath("//iati-activity/budget[2]/@status").text).to eq("1")
        expect(xml.xpath("//iati-activity/budget[2]/value").text).to eq("160.01")
      end
    end
  end

  context "when the activity has actuals" do
    it "only includes actuals which belong to the activity" do
      _actual = create(:actual, parent_activity: activity)
      _other_actual = create(:actual)

      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.xpath("//iati-activity/transaction").count).to eq(1)
    end

    it "has the correct transaction XML" do
      actual = create(:actual, parent_activity: activity)

      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.xpath("//iati-activity/transaction/transaction-type/@code").text).to eq("1")
      expect(xml.xpath("//iati-activity/transaction/receiver-org/narrative").text).to eq(actual.receiving_organisation_name)
      expect(xml.xpath("//iati-activity/transaction/value").text).to eq("110.01")
    end

    it "omits the receiving organisation if one is not present" do
      _actual = create(:actual, :without_receiving_organisation, parent_activity: activity)

      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.xpath("//iati-activity/transaction/transaction-type/@code").text).to eq("1")
      expect(xml.xpath("//iati-activity/transaction/value").text).to eq("110.01")
      expect(xml.xpath("//iati-activity/transaction/receiver-org").count).to eq(0)
    end
  end

  context "when the activity has forecasts" do
    let(:reporting_cycle) { ReportingCycle.new(activity, 1, 2019) }

    it "only includes forecasts (as planned-disbursement nodes) which belong to the activity" do
      reporting_cycle.tick
      ForecastHistory.new(activity, financial_quarter: 1, financial_year: 2020).set_value(10)
      ForecastHistory.new(create(:programme_activity), financial_quarter: 1, financial_year: 2020).set_value(10)

      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.xpath("//iati-activity/planned-disbursement").count).to eq(1)
    end

    it "only includes the latest values for forecasts" do
      q2_forecast = ForecastHistory.new(activity, financial_quarter: 2, financial_year: 2020)
      q3_forecast = ForecastHistory.new(activity, financial_quarter: 3, financial_year: 2020)

      reporting_cycle.tick
      q2_forecast.set_value(10)
      q3_forecast.set_value(20)

      reporting_cycle.tick
      q2_forecast.set_value(30)

      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.xpath("//iati-activity/planned-disbursement").count).to eq(2)
      expect(xml.xpath("//iati-activity/planned-disbursement/value").map(&:text)).to eq(["30.00", "20.00"])
    end

    it "has the period end date when one is supplied" do
      reporting_cycle.tick
      quarter = FinancialQuarter.for_date(Date.today)
      ForecastHistory.new(activity, **quarter).set_value(10)
      forecast = ForecastOverview.new(activity).latest_values.first
      forecast_presenter = ForecastXmlPresenter.new(forecast)

      visit organisation_activity_path(organisation, activity, format: :xml)

      expect(xml.xpath("//iati-activity/planned-disbursement/period-start/@iso-date").text).to eq forecast_presenter.period_start_date
      expect(xml.xpath("//iati-activity/planned-disbursement/period-end/@iso-date").text).to eq forecast_presenter.period_end_date
    end

    context "when the forecast receiving organisation type is 0" do
      it "does not output attributes on the receiving organisation element" do
        reporting_cycle.tick
        ForecastHistory.new(activity, **FinancialQuarter.for_date(Date.today)).set_value(10)
        Forecast.unscoped.update_all(receiving_organisation_type: "0")

        visit organisation_activity_path(organisation, activity, format: :xml)

        expect(xml.xpath("//iati-activity/planned-disbursement/receiver-org/@type")).to be_empty
        expect(xml.xpath("//iati-activity/planned-disbursement/receiver-org/@ref")).to be_empty
        expect(xml.xpath("//iati-activity/planned-disbursement/receiver-org/@receiver-activity-id")).to be_empty
      end
    end
  end
end
