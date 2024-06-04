class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  before_action :authorized

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless current_user
  end

  def current_user
    @current_user ||= AuthorizeApiRequest.new(request.headers).call[:user]
    @current_user ||= User.find(params[:user_id]) if params[:user_id]
    @current_user&.include_conversations
    @current_user
  end
end
