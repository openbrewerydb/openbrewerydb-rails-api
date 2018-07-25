# frozen_string_literal: true

require "rails_helper"

RSpec.describe AuthorizeApiRequest do
  let(:user) { create(:user) }
  let(:header) { { "Authorization" => token_generator(user.id) } }
  subject(:invalid_request) { described_class.new({}) }
  subject(:valid_request) { described_class.new(header) }

  describe "#call" do
    context "when valid request" do
      it "returns a user" do
        result = valid_request.call
        expect(result[:user]).to eq(user)
      end
    end

    context "when invalid request" do
      context "when missing token" do
        it "raises a MissingToken error" do
          expect { invalid_request.call }.to raise_error(
            ExceptionHandler::MissingToken
          )
        end
      end

      context "when invalid token" do
        subject(:invalid_request) do
          invalid_user_id = 100
          described_class.new(
            "Authorization" => token_generator(invalid_user_id)
          )
        end

        it "raises an InvalidToken error" do
          expect { invalid_request.call }.to raise_error(
            ExceptionHandler::InvalidToken
          )
        end
      end

      context "when token is expired" do
        let(:header) do
          {
            "Authorization" => token_generator(user.id, (Time.now.to_i - 10))
          }
        end
        subject(:valid_request) { described_class.new(header) }

        it 'raises an InvalidToken "Signature has expired" error' do
          expect { valid_request.call }.to raise_error(
            ExceptionHandler::InvalidToken,
            /Signature has expired/
          )
        end
      end

      context "when fake token" do
        let(:header) { { "Authorization" => "foobar" } }
        subject(:invalid_request) { described_class.new(header) }

        it 'raises an InvalidToken "Segment" error' do
          expect { invalid_request.call }.to raise_error(
            ExceptionHandler::InvalidToken,
            /Not enough or too many segments/
          )
        end
      end
    end
  end
end
