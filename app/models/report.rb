class Report < ApplicationRecord
  include PublicActivity::Common

  attr_readonly :financial_quarter, :financial_year

  validates_presence_of :description
  validates_presence_of :state

  belongs_to :fund, -> { where(level: :fund) }, class_name: "Activity"
  belongs_to :organisation
  has_many :transactions
  has_many :planned_disbursements

  validate :activity_must_be_a_fund
  validates :deadline, date_not_in_past: true, date_within_boundaries: true

  enum state: {
    inactive: "inactive",
    active: "active",
    submitted: "submitted",
    in_review: "in_review",
    awaiting_changes: "awaiting_changes",
    approved: "approved",
  }

  def initialize(attributes = nil)
    super(attributes)
    self.financial_quarter = current_financial_quarter
    self.financial_year = current_financial_year
  end

  def activity_must_be_a_fund
    return unless fund.present?
    unless fund.fund?
      errors.add(:fund, I18n.t("activerecord.errors.models.report.attributes.fund.level"))
    end
  end

  def next_four_financial_quarters
    case current_financial_quarter
    when 1
      ["Q2 #{current_financial_year}", "Q3 #{current_financial_year}", "Q4 #{current_financial_year}", "Q1 #{current_financial_year + 1}"]
    when 2
      ["Q3 #{current_financial_year}", "Q4 #{current_financial_year}", "Q1 #{current_financial_year + 1}", "Q2 #{current_financial_year + 1}"]
    when 3
      ["Q4 #{current_financial_year}", "Q1 #{current_financial_year + 1}", "Q2 #{current_financial_year + 1}", "Q3 #{current_financial_year + 1}"]
    when 4
      ["Q1 #{current_financial_year + 1}", "Q2 #{current_financial_year + 1}", "Q3 #{current_financial_year + 1}", "Q4 #{current_financial_year + 1}"]
    end
  end

  private def current_financial_quarter
    case Date.today.month
    when 4, 5, 6
      1
    when 7, 8, 9
      2
    when 10, 11, 12
      3
    when 1, 2, 3
      4
    end
  end

  private def current_financial_year
    year = Date.today.year
    return year - 1 if current_financial_quarter == 4
    year
  end
end
