RSpec.describe PlannedDisbursementHistory do
  let(:history) { PlannedDisbursementHistory.new(activity, 3, 2020) }

  def history_entries
    history.all_entries.map do |entry|
      [
        entry.planned_disbursement_type,
        entry.report&.financial_quarter,
        entry.report&.financial_year,
        entry.value,
      ]
    end
  end

  context "for a level B activity, owned by BEIS" do
    let(:activity) { create(:programme_activity) }

    it "begins with no entries" do
      expect(history_entries).to eq([])
    end

    it "creates an original entry when the value is first set" do
      history.set_value(10)

      expect(history_entries).to eq([
        ["original", nil, nil, 10],
      ])
    end

    it "adds a revision when the value is first updated" do
      history.set_value(10)
      history.set_value(20)

      expect(history_entries).to eq([
        ["original", nil, nil, 10],
        ["revised", nil, nil, 20],
      ])
    end

    it "modifies the revision on all further updates" do
      history.set_value(10)
      history.set_value(20)
      history.set_value(30)

      expect(history_entries).to eq([
        ["original", nil, nil, 10],
        ["revised", nil, nil, 30],
      ])
    end

    it "does not create a revision if the value is unchanged" do
      history.set_value(10)
      history.set_value(10)

      expect(history_entries).to eq([
        ["original", nil, nil, 10],
      ])
    end
  end
end
