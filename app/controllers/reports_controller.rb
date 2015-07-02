class ReportsController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  def index
    max_per_page = 5

    pre_paginated_reports = if params.has_key?(:keywords)

      keywords = params[:keywords]
      keyint = keywords.to_i
      template = current_user.templates.where(:name => keywords.to_s)

      if template.present?
        current_user.reports.where(:template_id => template.first.id)
      elsif keyint > 0
        current_user.reports.where(:id => keywords.to_i)
      elsif keywords.present?
        current_user.reports.where(:title => keywords.to_s)
      end

    else
      current_user.reports
    end

    paginate pre_paginated_reports.count, max_per_page do |limit, offset|
      render json: pre_paginated_reports
      .order(id: :desc)
      .limit(limit)
      .offset(offset)
      .to_json(
        :only => [:id, :title], 
        :include => [
          { :users => { :only => :uid } },
          { :template => { :only => :name } }
        ])
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
