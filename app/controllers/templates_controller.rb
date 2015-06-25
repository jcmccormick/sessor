class TemplatesController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  def index
  	@templates = if params[:id]
                 Template.where('id ilike ?',"%#{params[:id]}%")
               else
                 Template.all
               end
  end

  def show
  	@template = Template.find(params[:id])
  end

  def create
    @template = Template.new(allowed_params)
    @template.save
    render 'show', status: 201
  end

  def update
    template = Template.find(params[:id])
    template.update_attributes(allowed_params)
    head :no_content
  end

  def destroy
    template = Template.find(params[:id])
    template.destroy
    head :no_content
  end

  private
    def allowed_params
      params.require(:template).permit(:name, :sections, :creator_uid, :private_world, :private_group, :group_id, :group_edit, :group_editors)
    end
end
