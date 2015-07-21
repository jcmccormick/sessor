class FieldsController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  nested_attributes_names = Field.nested_attributes_options.keys.map do |key|
    key.to_s.concat('_attributes').to_sym
  end
  wrap_parameters include: Field.attribute_names + nested_attributes_names
  
  def show
  end

  def create
    column = Column.find(params[:column_id])
    @field = column.fields.new(allowed_params)
    @field.save
    render 'show', status: 201
  end

  def update
    field = Field.find(params[:id])
    field.update(allowed_params)
    head :no_content
  end

  def destroy
    field = Field.find(params[:id])
    field.destroy
    head :no_content
  end

  private
    def allowed_params
      params.require(:field).permit(:name, :fieldtype, :value, :required, :disabled, :glyphicon)
    end
end