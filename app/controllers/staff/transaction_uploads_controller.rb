# frozen_string_literal: true

require "csv"

class Staff::TransactionUploadsController < Staff::BaseController
  include Secured

  before_action :authorize_report

  def new
    @report_presenter = ReportPresenter.new(@report)
  end

  def show
    response.headers["Content-Type"] = "text/csv"
    response.headers["Content-Disposition"] = "attachment; filename=transactions.csv"

    response.stream.write(CSV.generate_line(csv_headers))
    @report.reportable_activities.each do |activity|
      response.stream.write(CSV.generate_line(csv_row(activity)))
    end
    response.stream.close
  end

  def update
    @report_presenter = ReportPresenter.new(@report)
    rows = parse_transactions_from_upload

    if rows.nil?
      @errors = []
      flash.now[:error] = t("action.transaction.upload.file_missing")
      return
    end

    importer = ImportTransactions.new(report: @report, uploader: current_user)
    importer.import(rows)
    @errors = importer.errors

    if @errors.empty?
      flash.now[:notice] = t("action.transaction.upload.success")
    end
  end

  private def authorize_report
    @report = Report.find(params[:report_id])
    authorize @report, :show?
  end

  private def csv_headers
    ["Activity Name", "Activity Delivery Partner Identifier"] + ImportTransactions.column_headings
  end

  private def csv_row(activity)
    [
      activity.description,
      activity.delivery_partner_identifier,
      activity.roda_identifier_compound,
    ]
  end

  private def parse_transactions_from_upload
    file = params[:report]&.fetch(:transaction_csv, nil)
    return nil unless file

    CSV.parse(file.read, headers: true)
  rescue
    nil
  end
end
