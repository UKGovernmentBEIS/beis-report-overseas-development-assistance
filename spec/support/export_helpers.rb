module ExportHelpers
  def value_for_header(header_name)
    values = subject.rows.fetch(@activity.id)
    values[subject.headers.index(header_name)]
  end

  def actuals_from_table(table)
    CSV.parse(table, col_sep: "|", headers: true).each do |row|
      case row["transaction"].strip
      when "Actual"
        create(:actual, fixture_attrs(row))
      when "Adj. Act."
        create(:adjustment, :actual, fixture_attrs(row))
      when "Adj. Ref."
        create(:adjustment, :refund, fixture_attrs(row))
      when "Refund"
        create(:refund, fixture_attrs(row))
      else
        raise "don't know what to do"
      end
    end
  end

  def add_budgets_from_table(table)
    CSV.parse(table, col_sep: "|", headers: true).map do |row|
      activity = Activity.find(row["programme_id"].strip)
      activity.budgets << create(
        :budget,
        value: row["value"].strip,
        financial_year: row["financial_year"].strip
      )
    end
  end

  def forecasts_for_report_from_table(report, table)
    CSV.parse(table, col_sep: "|", headers: true).each do |row|
      ForecastHistory.new(
        @activity,
        report: report,
        financial_quarter: row["financial_quarter"].to_i,
        financial_year: row["financial_year"].to_i
      ).set_value(row["value"].to_i)
    end
  end

  def fixture_attrs(row)
    {
      parent_activity: @activity,
      value: row["value"].strip,
      financial_quarter: row["financial_period"][/\d/],
      financial_year: 2020,
      report: instance_variable_get(:"@#{row["report"].strip}_report")
    }
  end
end
