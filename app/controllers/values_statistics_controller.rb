class ValuesStatisticsController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  def index
    render json: current_user.templates.all.to_json(
      :include => { :fields => {
        :include => :values
      }}
    )
  end
end