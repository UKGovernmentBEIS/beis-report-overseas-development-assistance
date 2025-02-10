RSpec.feature "BEIS users can download exports" do
  let(:beis_user) { create(:beis_user) }

  before do
    Fund.all.each { |fund| create(:fund_activity, source_fund_code: fund.id, roda_identifier: fund.short_name) }
    authenticate! user: beis_user
  end
  after { logout }

  scenario "downloading the actuals for a partner organisation" do
    partner_organisation = create(:partner_organisation)
    project = create(:project_activity, organisation: partner_organisation)
    create(:actual, parent_activity: project, financial_year: 2019, financial_quarter: 3, value: 150)

    visit exports_path
    click_link partner_organisation.name
    click_link "Download All actuals"
    document = CSV.parse(page.body.delete_prefix("\uFEFF"), headers: true).map(&:to_h)

    expect(document).to match_array([
      {
        "Activity RODA Identifier" => project.roda_identifier,
        "Activity BEIS Identifier" => project.beis_identifier,
        "FQ3 2019-2020" => "150.00"
      }
    ])
  end

  scenario "downloading the external income for a partner organisation" do
    partner_organisation = create(:partner_organisation)
    project = create(:project_activity, :newton_funded, organisation: partner_organisation)
    ext_income1 = create(:external_income, activity: project, financial_year: 2019, financial_quarter: 3, amount: 120)
    ext_income2 = create(:external_income, activity: project, financial_year: 2021, financial_quarter: 1, amount: 240)

    visit exports_path
    click_link partner_organisation.name
    click_link "Newton Fund external income"
    document = CSV.parse(page.body.delete_prefix("\uFEFF"), headers: true).map(&:to_h)

    expect(document.size).to eq(2)
    expect(document).to match_array([
      {
        "RODA identifier" => project.roda_identifier,
        "Partner organisation identifier" => project.partner_organisation_identifier,
        "Partner organisation" => partner_organisation.name,
        "Title" => project.title,
        "Level" => "Project (level C)",
        "Providing organisation" => ext_income1.organisation.name,
        "ODA" => "Yes",
        "FQ3 2019-2020" => "120.00",
        "FQ4 2019-2020" => "0.00",
        "FQ1 2020-2021" => "0.00",
        "FQ2 2020-2021" => "0.00",
        "FQ3 2020-2021" => "0.00",
        "FQ4 2020-2021" => "0.00",
        "FQ1 2021-2022" => "0.00"
      },
      {
        "RODA identifier" => project.roda_identifier,
        "Partner organisation identifier" => project.partner_organisation_identifier,
        "Partner organisation" => partner_organisation.name,
        "Title" => project.title,
        "Level" => "Project (level C)",
        "Providing organisation" => ext_income2.organisation.name,
        "ODA" => "Yes",
        "FQ3 2019-2020" => "0.00",
        "FQ4 2019-2020" => "0.00",
        "FQ1 2020-2021" => "0.00",
        "FQ2 2020-2021" => "0.00",
        "FQ3 2020-2021" => "0.00",
        "FQ4 2020-2021" => "0.00",
        "FQ1 2021-2022" => "240.00"
      }
    ])
  end

  scenario "downloading the external income for all partner organisations" do
    partner_organisation1, partner_organisation2 = create_list(:partner_organisation, 2)
    project1 = create(:project_activity, :newton_funded, organisation: partner_organisation1)
    project2 = create(:project_activity, :newton_funded, organisation: partner_organisation2)

    ext_income1 = create(:external_income, activity: project1, financial_year: 2019, financial_quarter: 3, amount: 120)
    ext_income2 = create(:external_income, activity: project2, financial_year: 2021, financial_quarter: 1, amount: 240)
    ext_income3 = create(:external_income, activity: project2, financial_year: 2021, financial_quarter: 2, amount: 100)

    visit exports_path
    click_link "Download External income for Newton Fund"

    document = CSV.parse(page.body.delete_prefix("\uFEFF"), headers: true).map(&:to_h)

    expect(document.size).to eq(3)

    expect(document).to match_array([
      {
        "RODA identifier" => project1.roda_identifier,
        "Partner organisation identifier" => project1.partner_organisation_identifier,
        "Partner organisation" => partner_organisation1.name,
        "Title" => project1.title,
        "Level" => "Project (level C)",
        "Providing organisation" => ext_income1.organisation.name,
        "ODA" => "Yes",
        "FQ3 2019-2020" => "120.00",
        "FQ4 2019-2020" => "0.00",
        "FQ1 2020-2021" => "0.00",
        "FQ2 2020-2021" => "0.00",
        "FQ3 2020-2021" => "0.00",
        "FQ4 2020-2021" => "0.00",
        "FQ1 2021-2022" => "0.00",
        "FQ2 2021-2022" => "0.00"
      },
      {
        "RODA identifier" => project2.roda_identifier,
        "Partner organisation identifier" => project2.partner_organisation_identifier,
        "Partner organisation" => partner_organisation2.name,
        "Title" => project2.title,
        "Level" => "Project (level C)",
        "Providing organisation" => ext_income2.organisation.name,
        "ODA" => "Yes",
        "FQ3 2019-2020" => "0.00",
        "FQ4 2019-2020" => "0.00",
        "FQ1 2020-2021" => "0.00",
        "FQ2 2020-2021" => "0.00",
        "FQ3 2020-2021" => "0.00",
        "FQ4 2020-2021" => "0.00",
        "FQ1 2021-2022" => "240.00",
        "FQ2 2021-2022" => "0.00"
      },
      {
        "RODA identifier" => project2.roda_identifier,
        "Partner organisation identifier" => project2.partner_organisation_identifier,
        "Partner organisation" => partner_organisation2.name,
        "Title" => project2.title,
        "Level" => "Project (level C)",
        "Providing organisation" => ext_income3.organisation.name,
        "ODA" => "Yes",
        "FQ3 2019-2020" => "0.00",
        "FQ4 2019-2020" => "0.00",
        "FQ1 2020-2021" => "0.00",
        "FQ2 2020-2021" => "0.00",
        "FQ3 2020-2021" => "0.00",
        "FQ4 2020-2021" => "0.00",
        "FQ1 2021-2022" => "0.00",
        "FQ2 2021-2022" => "100.00"
      }
    ])
  end

  scenario "downloading budgets for a partner organisation" do
    partner_organisation = create(:partner_organisation)

    report = create(:report)

    programme = create(:programme_activity, extending_organisation: partner_organisation)
    project = create(:project_activity, :newton_funded, extending_organisation: partner_organisation)

    create(:budget, financial_year: 2021, value: 1000, parent_activity: programme, report: nil)

    create(:budget, financial_year: 2018, value: 100, parent_activity: project, report: report)
    create(:budget, financial_year: 2019, value: 80, parent_activity: project, report: report)
    create(:budget, financial_year: 2020, value: 75, parent_activity: project, report: report)
    create(:budget, financial_year: 2021, value: 20, parent_activity: project, report: report)

    programme_comment = create(:comment, commentable: programme, owner: beis_user, body: "I am a programme comment")

    visit exports_path
    click_link partner_organisation.name
    click_link "Newton Fund budgets"

    document = CSV.parse(page.body.delete_prefix("\uFEFF"), headers: true).map(&:to_h)

    expect(document.size).to eq(2)

    expect(document).to match_array([
      {
        "RODA identifier" => programme.roda_identifier,
        "Partner organisation identifier" => programme.partner_organisation_identifier,
        "Partner organisation" => programme.extending_organisation.name,
        "Level" => "Programme (level B)",
        "Title" => programme.title,
        "Level B activity comments" => programme_comment.body,
        "2018-2019" => "0.00",
        "2019-2020" => "0.00",
        "2020-2021" => "0.00",
        "2021-2022" => "1000.00"
      },
      {
        "RODA identifier" => project.roda_identifier,
        "Partner organisation identifier" => project.partner_organisation_identifier,
        "Partner organisation" => partner_organisation.name,
        "Level" => "Project (level C)",
        "Title" => project.title,
        "Level B activity comments" => "",
        "2018-2019" => "100.00",
        "2019-2020" => "80.00",
        "2020-2021" => "75.00",
        "2021-2022" => "20.00"
      }
    ])
  end

  scenario "downloading budgets for all partner organisations" do
    partner_organisation1, partner_organisation2 = create_list(:partner_organisation, 2)

    report = create(:report)

    programme = create(:programme_activity)
    project1 = create(:project_activity, :newton_funded, extending_organisation: partner_organisation1, parent: programme)
    project2 = create(:project_activity, :newton_funded, extending_organisation: partner_organisation2, parent: programme)

    create(:budget, financial_year: 2021, value: 1000, parent_activity: programme, report: nil)

    create(:budget, financial_year: 2018, value: 100, parent_activity: project1, report: report)
    create(:budget, financial_year: 2019, value: 80, parent_activity: project1, report: report)
    create(:budget, financial_year: 2021, value: 20, parent_activity: project1, report: report)

    create(:budget, financial_year: 2018, value: 100, parent_activity: project2, report: report)
    create(:budget, financial_year: 2019, value: 80, parent_activity: project2, report: report)
    create(:budget, financial_year: 2020, value: 75, parent_activity: project2, report: report)
    create(:budget, financial_year: 2021, value: 20, parent_activity: project2, report: report)
    create(:budget, financial_year: 2021, value: 60, parent_activity: project2, report: report)

    programme_comment_1 = create(:comment, commentable: programme, owner: beis_user, body: "I like big budgets and I cannot lie")
    programme_comment_2 = create(:comment, commentable: programme, owner: beis_user, body: "The chief budgerigar asked if we could budge over this budget")

    visit exports_path
    click_link "Download Budgets for Newton Fund"

    document = CSV.parse(page.body.delete_prefix("\uFEFF"), headers: true).map(&:to_h)

    expect(document.size).to eq(4)

    expect(document).to match_array([
      {
        "RODA identifier" => programme.roda_identifier,
        "Partner organisation identifier" => programme.partner_organisation_identifier,
        "Partner organisation" => programme.extending_organisation.name,
        "Level" => "Programme (level B)",
        "Title" => programme.title,
        "Level B activity comments" => [programme_comment_1, programme_comment_2].map(&:body).join("|"),
        "2018-2019" => "0.00",
        "2019-2020" => "0.00",
        "2020-2021" => "0.00",
        "2021-2022" => "1000.00"
      },
      {
        "RODA identifier" => project1.roda_identifier,
        "Partner organisation identifier" => project1.partner_organisation_identifier,
        "Partner organisation" => partner_organisation1.name,
        "Level" => "Project (level C)",
        "Title" => project1.title,
        "Level B activity comments" => "",
        "2018-2019" => "100.00",
        "2019-2020" => "80.00",
        "2020-2021" => "0.00",
        "2021-2022" => "20.00"
      },
      {
        "RODA identifier" => project2.roda_identifier,
        "Partner organisation identifier" => project2.partner_organisation_identifier,
        "Partner organisation" => partner_organisation2.name,
        "Level" => "Project (level C)",
        "Title" => project2.title,
        "Level B activity comments" => "",
        "2018-2019" => "100.00",
        "2019-2020" => "80.00",
        "2020-2021" => "75.00",
        "2021-2022" => "20.00"
      },
      {
        "RODA identifier" => project2.roda_identifier,
        "Partner organisation identifier" => project2.partner_organisation_identifier,
        "Partner organisation" => partner_organisation2.name,
        "Level" => "Project (level C)",
        "Title" => project2.title,
        "Level B activity comments" => "",
        "2018-2019" => "0.00",
        "2019-2020" => "0.00",
        "2020-2021" => "0.00",
        "2021-2022" => "60.00"
      }
    ])
  end

  scenario "downloading IATI exports for a partner organisation" do
    organisation = create(:partner_organisation)
    publishable_activity = create(:programme_activity, :gcrf_funded, extending_organisation: organisation, publish_to_iati: true)
    unpublishable_activity = create(:programme_activity, :newton_funded, extending_organisation: organisation, publish_to_iati: false)

    visit exports_organisation_path(organisation)

    expect(page).to have_content("#{publishable_activity.source_fund.name} IATI export for programme (level B) activities")
    expect(page).not_to have_content("#{unpublishable_activity.source_fund.name} IATI export for programme (level B) activities")
  end

  scenario "downloading level B exports for a fund" do
    allow(ROLLOUT).to receive(:active?).with(:level_b_exports, beis_user).and_return(true)
    travel_to Time.zone.local(2025, 1, 21, 11, 26, 34)

    other_fund_programme = create(:programme_activity, :newton_funded)
    programme_1 = create(
      :programme_activity, :ispf_funded, commitment: create(:commitment, value: BigDecimal("250_000.00")),
      benefitting_countries: %w[AR EC BR], tags: [4, 5], transparency_identifier: "GB-GOV-26-1234-5678-91011"
    )
    programme_1.comments = create_list(:comment, 2)
    programme_1.budgets = [
      create(:budget, :with_revisions, number_of_revisions: 2, financial_year: 2023, value: 1.00),
      create(:budget, financial_year: 2024, value: 202.00),
      create(:budget, financial_year: 2025, value: 303.00)
    ]
    create(:programme_activity, :ispf_funded, is_oda: false)

    # When I visit the Exports
    visit exports_path

    # And I download “Level B activities for International Science Partnerships Fund” as CSV
    click_link "Download Level B activities for International Science Partnerships Fund"

    aggregate_failures do
      # Then I should have downloaded a file named for the fund and those activities with an appropriate timestamp in the filename
      expect(page.response_headers["Content-Disposition"]).to include(
        "attachment; filename=LevelB_International_Science_Partnerships_Fund_2025-01-21_11-26-34.csv"
      )

      document = CSV.parse(page.body.delete_prefix("\uFEFF"), headers: true).map(&:to_h)
      expect(document.size).to eq(2)
      programme_1_row = document.find { |row| row["RODA identifier"] == programme_1.roda_identifier }

      # And each row should have the columns requested in our Example XLSX
      expect(programme_1_row).to match(a_hash_including({
        "Partner Organisation" => programme_1.extending_organisation.name,
        "Activity level" => "Programme (level B)",
        "Parent activity" => "International Science Partnerships Fund",
        "ODA or Non-ODA" => "ODA",
        "Partner organisation identifier" => a_string_starting_with("GCRF-"),
        "RODA identifier" => a_string_starting_with("ISPF-"),
        "IATI identifier" => a_string_starting_with("GB-GOV-"),
        "Linked activity" => nil,
        "Activity title" => programme_1.title,
        "Activity description" => programme_1.description,
        "Aims or objectives" => programme_1.objectives,
        "Sector" => "11110: Education policy and administrative management",
        "Original commitment figure" => "£250,000.00",
        "Activity status" => "Spend in progress",
        "Planned start date" => "21 Jan 2025",
        "Planned end date" => "22 Jan 2025",
        "Actual start date" => "20 Jan 2025",
        "Actual end date" => "21 Jan 2025",
        "ISPF ODA partner countries" => "India (ODA)",
        "Benefitting countries" => "Argentina; Ecuador; Brazil",
        "Benefitting region" => "South America, regional",
        "Global Development Impact" => "GDI not applicable",
        "Sustainable Development Goals" => "Not applicable",
        "ISPF themes" => "Resilient Planet",
        "Aid type" => "D01: Donor country personnel",
        "ODA eligibility" => "Eligible",
        "Publish to IATI?" => "Yes",
        "Tags" => "Tactical Fund|Previously reported under OODA",
        "Budget 2023-2024" => "£101.00", # each revision adds £50 in the factories; we have 2
        "Budget 2024-2025" => "£202.00",
        "Budget 2025-2026" => "£303.00",
        "Comments" => (
          a_string_matching(programme_1.comments.first.body) &
            a_string_matching("|") &
            a_string_matching(programme_1.comments.second.body)
        )
      })).and(have_attributes(length: 33))

      # And that file should contain no level B activities for any other fund
      expect(document.none? { |row| row["RODA Identifier"] == other_fund_programme.roda_identifier }).to be true

      # And that file should distinguish between ODA and non-ODA activities for ISPF only
      expect(document.last).to match(
        a_hash_including({"ODA or Non-ODA" => "Non-ODA"})
      )
    end
  end
end
