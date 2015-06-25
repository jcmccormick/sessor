class GroupsController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  def index
  	@groups = if params[:id]
                 Group.where('id ilike ?',"%#{params[:id]}%")
               else
                 Group.all
               end
  end

  def show
  	@group = Group.find(params[:id])
  end

  def create
    @group = Group.new(allowed_params)
    @group.save
    render 'show', status: 201
  end

  def update
    group = Group.find(params[:id])
    group.update_attributes(allowed_params)
    head :no_content
  end

  def destroy
    group = Group.find(params[:id])
    group.destroy
    head :no_content
  end

  private
    def allowed_params
      params.require(:group).permit(:name, :owner, :members, :templates)
    end
end
