class ReportsController < ApplicationController
  include ActionView::Helpers::TextHelper
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  nested_attributes_names = Report.nested_attributes_options.keys.map do |key|
    key.to_s.concat('_attributes').to_sym
  end
  wrap_parameters include: Report.attribute_names + nested_attributes_names

  def index
    max_per_page = 5

    pre_paginated_reports = if params.has_key?(:keywords)

      keywords = params[:keywords]
      template = current_user.templates.where(:name => keywords)

      query = if template.present?
        {:template_id => template.first.id}
      elsif keywords.to_i > 0
        {:id => keywords.to_i}
      elsif keywords.length > 0
        {:title => keywords}
      end
      current_user.reports.where(query)
    else
      current_user.reports
    end

    paginate pre_paginated_reports.count, max_per_page do |limit, offset|
      render json: pre_paginated_reports
      .order(id: :desc)
      .limit(limit)
      .offset(offset)
      .as_json(
        :only => [:id, :title], 
        :include => [
          { :users => { :only => :uid } },
          { :templates => { :only => :name } }
        ])
    end
  end

  def show
    report = current_user.reports.find(params[:id])
    render json: report
  end

  def create
    template = current_user.templates.find(params[:template_ids])
    @report = current_user.reports.new(allowed_params)
    @report.templates << template
    @report.save
    current_user.reports << @report
    render 'show', status: 201
  end

  def update
    report = current_user.reports.find(params[:id])
    params[:template_ids].each do |template_id|
      template = current_user.templates.find(template_id)
      report.templates << template unless report.templates.include?(template)
    end
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
      params.require(:report).permit(
        :title, :submission, :response, :active, :location,
        values_attributes: [
          :id, :input
        ]      
      )
    end
end
