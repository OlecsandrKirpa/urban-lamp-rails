# frozen_string_literal: true

RSpec.shared_context 'controller authentication' do
  attr_reader :current_user

  def authenticate_request
    @user = create(:user)
    @user.save! if @user.new_record?
    @refresh_token = create(:refresh_token, user: @user)
    @current_user = @user.reload

    @request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(user_id: @user.id, role: @user.role, refresh_token_id: @refresh_token.id)}"
  end

  before do
    authenticate_request
  end
end
