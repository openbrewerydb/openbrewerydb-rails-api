# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users API", type: :request do
  let(:user) { build(:user) }
  let(:valid_attributes) { attributes_for(:user) }

  describe "POST /signup" do
    context "when valid request" do
      before { post "/signup", params: valid_attributes }

      it "returns a 201 status" do
        expect(response).to have_http_status(:created)
      end

      it "returns a success message" do
        expect(json["message"]).to match(/Account created successfully/)
      end
    end

    context "when invalid request" do
      before { post "/signup", params: {} }

      it "returns a 422 status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns failure message" do
        expect(json["message"]).to match(
          /Validation failed: Password can't be blank, Email can't be blank/
        )
      end
    end
  end
end
