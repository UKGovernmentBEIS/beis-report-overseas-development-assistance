class Export::ActivitiesLevelB
  Field = Data.define(:name, :fund, :value)

  # A place to:
  #   - Name all the fields on the left
  #   - filter applicable fields on a per-fund basis in the middle
  #   - evaluate a row's values in the context of a fund's activity via a `value` Proc on the right
  #   - show all this on a line-by-line basis to avoid one tall export per fund, given
  #     there are many common fields
  # standard:disable Layout/ExtraSpacing
  FIELDS = [
    Field.new("Partner Organisation",                      "ALL",  -> { activity.extending_organisation.name }),
    Field.new("Activity level",                            "ALL",  -> { activity.level }),
    Field.new("Parent activity",                           "ALL",  -> { activity.source_fund.name }),
    Field.new("ODA or Non-ODA",                            "ISPF", -> { activity.is_oda }),
    Field.new("Partner organisation identifier",           "ALL",  -> { activity.partner_organisation_identifier }),
    Field.new("RODA identifier",                           "ALL",  -> { activity.roda_identifier }),
    Field.new("IATI identifier",                           "ALL",  -> { activity.transparency_identifier }),
    Field.new("Linked activity",                           "ALL",  -> { activity.linked_activity_identifier }),
    Field.new("Activity title",                            "ALL",  -> { activity.title }),
    Field.new("Activity description",                      "ALL",  -> { activity.description }),
    Field.new("Aims or objectives",                        "ALL",  -> { activity.objectives }),
    Field.new("Sector",                                    "ALL",  -> { activity.sector }),
    Field.new("Original commitment figure",                "ALL",  -> { activity.commitment&.value }),
    Field.new("Activity status",                           "ALL",  -> { activity.programme_status }),
    Field.new("Planned start date",                        "ALL",  -> { activity.planned_start_date }),
    Field.new("Planned end date",                          "ALL",  -> { activity.planned_end_date }),
    Field.new("Actual start date",                         "ALL",  -> { activity.actual_start_date }),
    Field.new("Actual end date",                           "ALL",  -> { activity.actual_end_date }),
    Field.new("ISPF ODA partner countries",                "ISPF", -> { activity.ispf_oda_partner_countries }),
    Field.new("ISPF non-ODA partner countries",            "ISPF", -> { activity.ispf_non_oda_partner_countries }),
    Field.new("GCRF Strategic Area",                       "GCRF", -> { activity.gcrf_strategic_area }),
    Field.new("GCRF Challenge Area",                       "GCRF", -> { activity.gcrf_challenge_area }),
    Field.new("Newton Fund Country Partner Organisations", "NF",   -> { activity.country_partner_organisations }),
    Field.new("Newton Fund Pillar",                        "NF",   -> { activity.fund_pillar }),
    Field.new("Benefitting countries",                     "ALL",  -> { activity.benefitting_countries }),
    Field.new("Benefitting region",                        "ALL",  -> { activity.benefitting_region }),
    Field.new("Global Development Impact",                 "ALL",  -> { activity.gdi }),
    Field.new("Sustainable Development Goals",             "ALL",  -> { activity.sustainable_development_goals }),
    Field.new("ISPF themes",                               "ISPF", -> { activity.ispf_themes }),
    Field.new("Aid type",                                  "ALL",  -> { activity.aid_type }),
    Field.new("ODA eligibility",                           "ALL",  -> { activity.oda_eligibility }),
    Field.new("Publish to IATI?",                          "ALL",  -> { activity.publish_to_iati }),
    Field.new("Tags",                                      "ISPF", -> { activity.tags }),
    # Budgets are inserted here, BEFORE_COMMENTS
    Field.new("Comments",                                  "ALL",  -> { activity.comments.map(&:body).join("|") })
  ].freeze
  # standard:enable Layout/ExtraSpacing

  # Given a fund, an activity, and all the +fields+, return all the cell +#value+s in a row
  # via +#to_a+. +Struct+ is needed because +@budgets_by_year+ is memoised
  Row = Struct.new(:fund, :activity, :fields) do
    def to_a
      fields.map do |field|
        instance_exec(&field.value) # get the field's value from its Proc in the context of this Row
      end
    end

    private

    def budgets_by_year
      @budgets_by_year ||= activity.budgets.each_with_object({}) do |budget, years|
        years[budget.financial_year.start_year] = BudgetPresenter.new(budget)
      end
    end
  end

  attr_reader :fund

  def initialize(fund:)
    @fund = fund
  end

  # @return [String] the name of the file, e.g. "LevelB_Newton_Fund_2025-02-10_10-50-59.csv"
  def filename
    "LevelB_#{fund.name.tr(" ", "_")}_#{Time.zone.now.strftime("%Y-%m-%d_%H-%M-%S")}.csv"
  end

  # @return [Array<String>] a row of heading column names
  def headers
    fields.map(&:name)
  end

  # @return [Array<String>] a row of report values for an activity
  def rows
    activities.map do |activity|
      Row.new(fund:, activity: ActivityCsvPresenter.new(activity), fields:).to_a
    end
  end

  private

  BEFORE_COMMENTS = -2
  # @return [Array<Field>] fields for this fund, including applicable budget year fields
  def fields
    @fields ||= FIELDS.select { |field| field.fund.in? ["ALL", fund.short_name] }.tap do |fields|
      fields.insert(BEFORE_COMMENTS, *applicable_budget_year_fields)
    end
  end

  # Header and Row both need to know ahead of time the extents of the budget years in order
  # to insert a constant number of columns. Dynamically instantiate these fields once.
  # @return [Array<Field>] the budget fields that apply to this report
  def applicable_budget_year_fields
    applicable_budget_years.map do |year|
      Field.new("Budget #{year}-#{year + 1}", "ALL", -> { budgets_by_year[year]&.value })
    end
  end

  # @return [Array<Integer>] the sorted list of years for which this fund's activities have budgets
  def applicable_budget_years
    activities.each_with_object(Set.new) do |activity, years|
      activity.budgets.each { |budget| years << budget.financial_year.start_year }
    end.sort
  end

  def activities
    @activities ||= fund.activity.child_activities
      .includes(:organisation, :extending_organisation, :commitment, :budgets, :linked_activity, :comments)
  end
end
