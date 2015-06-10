class ReportsController < ApplicationController

  before_filter :authenticate_user!

  skip_before_filter :verify_authenticity_token

  def index
  	@reports = Report.all
  end

  def show
  	@report = Report.find(params[:id])
  end

  def create
    @report = Report.new(allowed_params)
    @report.save
    render 'show', status: 201
  end

  def update
    report = Report.find(params[:id])
    report.update_attributes(allowed_params)
    head :no_content
  end

  def destroy
    report = Report.find(params[:id])
    report.destroy
    head :no_content
  end

  private
    def allowed_params
      params.require(:report).permit(:name, :submission, :response, :active, :location, :participants)
    end
end
