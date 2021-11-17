require "rails_helper"

RSpec.describe UniqueImplementingOrganisation, type: :model do
  describe "::find_matching" do
    let!(:canonical) do
      create(
        :unique_implementing_org,
        name: "canonical",
        legacy_names: ["uncanonical", "non_canonical"]
      )
    end

    it "finds the canonical record when the search term matches the name" do
      expect(UniqueImplementingOrganisation.find_matching("canonical"))
        .to eq(canonical)
    end

    it "finds the canonical record when the search term matches any legacy name" do
      aggregate_failures do
        expect(UniqueImplementingOrganisation.find_matching("uncanonical"))
          .to eq(canonical)

        expect(UniqueImplementingOrganisation.find_matching("non_canonical"))
          .to eq(canonical)
      end
    end
  end

  describe "::with_legacy_name scope" do
    let!(:canonical) do
      create(
        :unique_implementing_org,
        name: "canonical",
        legacy_names: ["uncanonical", "non_canonical"]
      )
    end

    it "finds the cananonical record when the search matches any legacy name" do
      aggregate_failures do
        expect(UniqueImplementingOrganisation.with_legacy_name("uncanonical"))
          .to include(canonical)

        expect(UniqueImplementingOrganisation.with_legacy_name("non_canonical"))
          .to include(canonical)
      end
    end
  end
end
