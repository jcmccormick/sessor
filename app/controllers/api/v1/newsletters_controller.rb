class NewslettersController < ApplicationController

  def create
    Newsletter.create(allowed_params)
    render 'show', status: 201
  end

  private
    def allowed_params
      params.require(:nv).permit(:email)
    end
end