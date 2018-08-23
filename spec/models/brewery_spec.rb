# frozen_string_literal: true

require "rails_helper"

RSpec.describe Brewery, type: :model do
  it { should validate_presence_of(:name) }

  describe "#address" do
    let(:brewery) { create(:brewery) }

    it "returns a full address" do
      expect(brewery.address).to eq(
        "#{brewery.street}, #{brewery.city}, #{brewery.state}, #{brewery.country}"
      )
    end
  end
end
