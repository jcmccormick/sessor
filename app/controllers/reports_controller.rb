class ReportsController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  def index
    max_per_page = 5

    paginate current_user.reports.count, max_per_page do |limit, offset|
      render json: current_user.reports.limit(limit).offset(offset).to_json( :only => [:id, :title], :include => [ { :users => { :only => [ :id, :uid ] } },{ :template => { :only => :name } } ] )
    end
  end

  def show
  	@report = current_user.reports.find(params[:id])
  end

  def create
    @report = current_user.reports.new(allowed_params)
    @report.template = current_user.templates.find(params[:template_id])
    @report.save
    current_user.reports << @report
    render 'show', status: 201
  end

  def update
    report = current_user.reports.find(params[:id])
    report.update_attributes(allowed_params)
    current_user.reports << report unless current_user.reports.include?(report)
    head :no_content
  end

  def destroy
    report = current_user.reports.find(params[:id])
    report.destroy
    head :no_content
  end

  private
    def allowed_params
      params.require(:report).permit(:title, :sections)
    end
end
