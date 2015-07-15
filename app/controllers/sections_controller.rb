class SectionsController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  def show
  end

  def create
    template = current_user.templates.find(params[:template_id])
    @section = template.sections.new(allowed_params)
    @section.save
    render 'show', status: 201
  end

  def update
    section = Section.find(params[:id])
    section.update(allowed_params)
    head :no_content
  end

  def destroy
    section = Section.find(params[:id])
    section.destroy
    head :no_content
  end

  private
    def allowed_params
      params.require(:section).permit(:name)
    end
end