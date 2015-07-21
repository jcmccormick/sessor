class ColumnsController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  nested_attributes_names = Column.nested_attributes_options.keys.map do |key|
    key.to_s.concat('_attributes').to_sym
  end
  wrap_parameters include: Column.attribute_names + nested_attributes_names

  def show
  end

  def create
    section = Section.find(params[:section_id])
    @column = section.columns.new(allowed_params)
    @column.save
    render 'show', status: 201
  end

  def update
    column = Column.find(params[:id])
    column.update(allowed_params)
    head :no_content
  end

  def destroy
    column = Column.find(params[:id])
    column.destroy
    head :no_content
  end

  private
    def allowed_params
      params.require(:column).permit()
    end
end