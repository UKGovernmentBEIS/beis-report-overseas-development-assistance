require "rails_helper"

RSpec.describe UpdateTransaction do
  let(:transaction) { create(:transaction) }

  describe "#call" do
    it "returns a successful result" do
      allow(transaction).to receive(:valid?).and_return(true)
      allow(transaction).to receive(:save).and_return(true)

      result = described_class.new(transaction: transaction).call(attributes: {})

      expect(result.success?).to be true
    end

    context "when the transaction isn't valid" do
      it "returns a failed result" do
        allow(transaction).to receive(:valid?).and_return(false)

        result = described_class.new(transaction: transaction).call(attributes: {})

        expect(result.success?).to be false
      end
    end

    context "when attributes are passed in" do
      it "sets the attributes passed in as transaction attributes" do
        attributes = ActionController::Parameters.new(reference: "foo").permit!

        result = described_class.new(transaction: transaction).call(attributes: attributes)

        expect(result.object.reference).to eq("foo")
      end
    end

    context "when unknown attributes are passed in" do
      it "raises an error" do
        attributes = ActionController::Parameters.new(foo: "bar").permit!

        expect { described_class.new(transaction: transaction).call(attributes: attributes) }
          .to raise_error(ActiveModel::UnknownAttributeError)
      end
    end

    context "when a value is passed in" do
      context "and that value contains alphabetical characters" do
        it "sets a value without these characters" do
          attributes = ActionController::Parameters.new(value: "abc 123.00 xyz").permit!

          result = described_class.new(transaction: transaction).call(attributes: attributes)

          expect(result.object.value).to eq(BigDecimal("123.00"))
        end
      end

      context "and that value contains currency characters" do
        it "sets a value without these characters" do
          attributes = ActionController::Parameters.new(value: "£123.00").permit!

          result = described_class.new(transaction: transaction).call(attributes: attributes)

          expect(result.object.value).to eq(BigDecimal("123.00"))
        end
      end

      context "and that value contains commas" do
        it "sets a value without these characters" do
          attributes = ActionController::Parameters.new(value: "1,230.90").permit!

          result = described_class.new(transaction: transaction).call(attributes: attributes)

          expect(result.object.value).to eq(BigDecimal("1230.90"))
        end
      end

      context "and that value contains a single decimal place" do
        it "sets a value to 1 decimal place and omits the trailing zero" do
          attributes = ActionController::Parameters.new(value: "1.1").permit!

          result = described_class.new(transaction: transaction).call(attributes: attributes)

          expect(result.object.value).to eq(BigDecimal("1.1"))
          expect(result.object.value).to eq(BigDecimal("1.10"))
        end
      end

      context "and that value contains 2 decimal places" do
        it "sets a value to 2 decimal places" do
          attributes = ActionController::Parameters.new(value: "1.11").permit!

          result = described_class.new(transaction: transaction).call(attributes: attributes)

          expect(result.object.value).to eq(BigDecimal("1.11"))
        end
      end

      context "and that value contains more than 2 decimal places" do
        it "rounds the value back up to 2 decimal places" do
          attributes = ActionController::Parameters.new(value: "1.115").permit!

          result = described_class.new(transaction: transaction).call(attributes: attributes)

          expect(result.object.value).to eq(BigDecimal("1.12"))
        end
      end
    end
  end
end
