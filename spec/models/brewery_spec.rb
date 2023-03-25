# frozen_string_literal: true

require "rails_helper"

RSpec.describe Brewery do
  describe "#model_validation" do
    subject(:brewery) { described_class.new(id:, name:, city:, state_province:, country:) }

    let(:id) { SecureRandom.uuid }
    let(:name) { "brewery-name" }
    let(:city) { "brewery-city" }
    let(:state_province) { nil }
    let(:country) { nil }

    context "when state is present" do
      let(:state_province) { "brewery-state" }
      let(:country) { "United States" }

      it "validates successfully" do
        expect(brewery.valid?).to be true
      end
    end

    context "when state is nil" do
      let(:country) { "United States" }

      it "fails validation" do
        expect(brewery.valid?).to be false
      end
    end
  end

  describe "#address" do
    subject(:brewery) { create(:brewery) }

    it "returns a full address" do
      expect(brewery.address).to eq(
        "#{brewery.address_1}, #{brewery.city}, #{brewery.state_province}, #{brewery.country}"
      )
    end
  end
end
