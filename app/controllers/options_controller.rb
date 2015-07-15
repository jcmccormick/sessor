class OptionsController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  def show
  end

  def create
    field = Field.find(params[:field_id])
    @option = field.options.new(allowed_params)
    @option.save
    render 'show', status: 201
  end

  def update
    option = Option.find(params[:id])
    option.update(allowed_params)
    head :no_content
  end

  def destroy
    option = Option.find(params[:id])
    option.destroy
    head :no_content
  end

  private
    def allowed_params
      params.require(:option).permit(:name)
    end
end