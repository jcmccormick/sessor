class ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  wrap_parameters false
  include ActionController::MimeResponds
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |type|
      type.all  { render 'show' => true, :status => 404 }
    end
  end
end