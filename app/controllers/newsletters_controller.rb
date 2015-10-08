class NewslettersController < ApplicationController

  def create
    Newsletter.create(allowed_params)
    head :no_content
  end

  private
    def allowed_params
      params.require(:newsletter).permit(:email)
    end
end