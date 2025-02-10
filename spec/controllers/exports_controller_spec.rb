require "rails_helper"

RSpec.describe ExportsController do
  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  let(:fund) { Fund.by_short_name("NF") }

  describe "#index" do
    context "when logged in as a partner organisation user" do
      let(:user) { create(:partner_organisation_user) }

      it "does not allow the user to access the index" do
        get "index"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when logged in as a BEIS user" do
      let(:user) { create(:beis_user) }

      it "fetches all the funds" do
        expect(Fund).to receive(:all)

        get "index"
      end
    end
  end

  describe "#external_income" do
    before do
      get "external_income", params: {fund_id: fund.id, format: :csv}
    end

    context "when logged in as a partner organisation user" do
      let(:user) { create(:partner_organisation_user) }

      it "does not allow the user to access the download" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when logged in as a BEIS user" do
      let(:user) { create(:beis_user) }

      it "responds with status 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "sets the CSV headers correctly" do
        expect(response.headers.to_h).to include({
          "Content-Type" => "text/csv"
        })
      end

      it "returns a CSV of all of the exports" do
        expect(CSV.parse(response.body.delete_prefix("\uFEFF")).first).to match_array(ExternalIncome::Export::HEADERS)
      end
    end
  end

  describe "#budgets" do
    before do
      get "budgets", params: {fund_id: fund.id, format: :csv}
    end

    context "when logged in as a partner organisation user" do
      let(:user) { create(:partner_organisation_user) }

      it "does not allow the user to access the download" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when logged in as a BEIS user" do
      let(:user) { create(:beis_user) }

      it "responds with status 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "sets the CSV headers correctly" do
        expect(response.headers.to_h).to include({
          "Content-Type" => "text/csv"
        })
      end

      it "returns a CSV of all of the exports" do
        expect(CSV.parse(response.body.delete_prefix("\uFEFF")).first).to match_array(Budget::Export::HEADERS)
      end
    end
  end

  describe "#level_b" do
    before do
      create :fund_activity, :newton
      get "level_b", params: {fund_id: fund.id, format: :csv}
    end

    context "when logged in as a partner organisation user" do
      let(:user) { create(:partner_organisation_user) }

      it "does not allow the user to access the download" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "when logged in as a BEIS user" do
      let(:user) { create(:beis_user) }

      it "responds with status 200 OK" do
        expect(response).to have_http_status(:ok)
      end

      it "sets the CSV headers correctly" do
        expect(response.headers.to_h).to include({
          "Content-Type" => "text/csv"
        })
      end

      it "returns a CSV of all of the exports" do
        header = CSV.parse(response.body.delete_prefix("\uFEFF")).first
        expect(header.length).to be > 1
      end
    end
  end

  describe "#spending_breakdown" do
    render_views
    let(:user) { create(:beis_user) }

    before do
      allow(SpendingBreakdownJob).to receive(:perform_later)
    end

    it "kicks off async job to create the CSV, upload to S3 & email download link" do
      get "spending_breakdown", params: {fund_id: fund.id}

      expect(SpendingBreakdownJob).to have_received(:perform_later).with(
        requester_id: user.id,
        fund_id: fund.id.to_s
      )
    end

    it "responds with the 'export_in_progress' template" do
      get "spending_breakdown", params: {fund_id: fund.id}

      expect(response).to render_template(:export_in_progress)
    end
  end

  describe "#spending_breakdown_download" do
    let(:user) { create(:beis_user) }
    let(:downloader) { double(:downloader, download: "file contents") }
    let!(:newton_fund) { create(:fund_activity, :newton, spending_breakdown_filename: "spending_breakdown.csv") }

    before do
      allow(Export::S3Downloader).to receive(:new).and_return(downloader)
    end

    it "requests a download from S3" do
      get "spending_breakdown_download", params: {id: fund.id}

      expect(Export::S3Downloader).to have_received(:new).with(filename: "spending_breakdown.csv")
      expect(downloader).to have_received(:download)
    end

    it "sets the headers correctly" do
      get "spending_breakdown_download", params: {id: fund.id}

      expect(response.headers.to_h).to include({
        "Content-Type" => "text/csv",
        "Content-Disposition" => "attachment; filename=#{ERB::Util.url_encode("spending_breakdown.csv")}"
      })
    end
  end
end
