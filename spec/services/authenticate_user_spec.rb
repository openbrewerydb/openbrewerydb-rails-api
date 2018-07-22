require 'rails_helper'

RSpec.describe AuthenticateUser do
  let(:user) { create(:user) }
  subject(:valid_auth_request) { described_class.new(user.email, user.password) }
  subject(:invalid_auth_request) { described_class.new('foo', 'bar') }

  describe '#call' do
    context 'when valid credentials' do
      it 'returns an auth token' do
        token = valid_auth_request.call
        expect(token).to_not be_nil
      end
    end

    context 'when ionvalid credentials' do
      it 'raises an authorization error' do
        expect { invalid_auth_request.call }.to raise_error(
          ExceptionHandler::AuthenticationError,
          /Invalid credentials/
        )
      end
    end
  end
end