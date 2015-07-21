class ValuesController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token
  
  def show
  end

  def create
    field = Field.find(params[:field_id])
    @value = field.values.new(allowed_params)
    @value.save
    render 'show', status: 201
  end

  def update
    value = Value.find(params[:id])
    value.update(allowed_params)
    head :no_content
  end

  def destroy
    value = Value.find(params[:id])
    value.destroy
    head :no_content
  end

  private
    def allowed_params
      params.require(:value).permit(:input)
    end
end