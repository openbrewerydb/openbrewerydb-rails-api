# frozen_string_literal: true

require "rails_helper"

RSpec.describe Brewery, type: :model do
  describe '#model_validation' do
    subject { Brewery.new(obdb_id: obdb_id, name: name, city: city, state: state, country: country) }
    let(:obdb_id) { 'brewery-id' }
    let(:name) { 'brewery-name' }
    let(:city) { 'brewery-city' }
    let(:state) { nil }
    let(:country) { nil }

    context 'when country is US' do
      context 'when state is present' do
        let(:state) { 'brewery-state' }
        let(:country) { 'United States' }
        it 'validates successfully' do
          expect(subject.valid?).to eq true
        end
      end
      
      context 'when state is nil' do
        let(:country) { 'United States' }
        it 'fails validation' do
          expect(subject.valid?).to eq false
        end
      end
    end

    context 'when country is not US' do
      let(:country) { 'Ireland' }
      it 'validates successfully' do
        expect(subject.valid?).to eq true
      end
    end
  end

  describe "#address" do
    let(:brewery) { create(:brewery) }
    
    it "returns a full address" do
      expect(brewery.address).to eq(
        "#{brewery.street}, #{brewery.city}, #{brewery.state}, #{brewery.country}"
      )
    end
  end
end
