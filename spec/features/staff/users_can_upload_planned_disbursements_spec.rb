RSpec.feature "users can upload planned disbursements" do
  let(:organisation) { create(:organisation) }
  let(:user) { create(:delivery_partner_user, organisation: organisation) }

  let!(:project) { create(:project_activity, organisation: organisation) }
  let!(:sibling_project) { create(:project_activity, organisation: organisation, parent: project.parent) }
  let!(:cousin_project) { create(:project_activity, organisation: organisation) }

  let! :report do
    create(:report,
      state: :active,
      fund: project.associated_fund,
      organisation: organisation,
      financial_year: 2021,
      financial_quarter: 1)
  end

  before do
    authenticate!(user: user)
    visit report_path(report)
    click_link t("action.planned_disbursement.upload.link")
  end

  scenario "downloading a CSV template with activities for the current report" do
    click_link t("action.planned_disbursement.download.button")

    rows = CSV.parse(page.body, headers: true).map(&:to_h)

    expect(rows).to match_array([
      {
        "Activity Name" => project.title,
        "Activity Delivery Partner Identifier" => project.delivery_partner_identifier,
        "Activity RODA Identifier" => project.roda_identifier,
      },
      {
        "Activity Name" => sibling_project.title,
        "Activity Delivery Partner Identifier" => sibling_project.delivery_partner_identifier,
        "Activity RODA Identifier" => sibling_project.roda_identifier,
      },
    ])
  end

  scenario "not uploading a file" do
    click_button t("action.planned_disbursement.upload.button")
    expect(PlannedDisbursement.count).to eq(0)
    expect(page).to have_text(t("action.planned_disbursement.upload.file_missing"))
  end

  scenario "uploading a valid set of forecasts" do
    ids = [project, sibling_project].map(&:roda_identifier)

    upload_csv <<~CSV
      Activity RODA Identifier | FC 2021/22 FY Q2 | FC 2021/22 FY Q3 | FC 2021/22 FY Q4
      #{ids[0]}                | 10               | 20               | 30
      #{ids[1]}                | 40               | 50               | 60
    CSV

    expect(PlannedDisbursement.count).to eq(6)
    expect(page).to have_text(t("action.planned_disbursement.upload.success"))
    expect(page).not_to have_xpath("//tbody/tr")
  end

  def upload_csv(content)
    file = Tempfile.new("forecasts.csv")
    file.write(content.gsub(/ *\| */, ","))
    file.close

    attach_file "report[planned_disbursement_csv]", file.path
    click_button t("action.planned_disbursement.upload.button")

    file.unlink
  end
end
