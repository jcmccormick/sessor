class TemplatesController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  wrap_parameters include: [:name, :creator_uid, :private_world, :private_group, :group_id, :group_edit, :group_editors, :allow_title, :sections_attributes]

  def index
    max_per_page = 5

    paginate current_user.templates.count, max_per_page do |limit, offset|
      render json: current_user.templates.limit(limit).offset(offset)
    end
  end

  def show
    render json: current_user.templates.find(params[:id]).as_json(
      :include => { :sections => {
        :include => { :columns => {
          :include => { :fields => {
            :include => :options
          }}
        }}
      }}
    )
  end

  def create
    @template = current_user.templates.new(allowed_params)
    @template.save
    current_user.templates << @template
    render 'show', status: 201
  end

  def update
    if params[:sections]
      params[:template][:sections_attributes] = params[:sections]
      params[:template][:sections_attributes].each do |paramSection|
        paramSection[:columns_attributes] = paramSection[:columns]
        paramSection[:columns_attributes].each do |paramColumn|
          paramColumn[:fields_attributes] = paramColumn[:fields]
          paramColumn[:fields_attributes].each do |paramField|
            paramField[:options_attributes] = paramField[:options]
          end
        end
      end
    end
    template = current_user.templates.find(params[:id])
    template.update_attributes(allowed_params)
    current_user.templates << template unless current_user.templates.include?(template)
    head :no_content
  end

  def destroy
    template = current_user.templates.find(params[:id])
    template.destroy
    head :no_content
  end

  private
    def allowed_params
      params.require(:template).permit(
        :name, :creator_uid, :private_world, :private_group, :group_id, :group_edit, :group_editors, :allow_title, 
        sections_attributes: [
          :id, :template_id, :name, :created_at, :updated_at,
          columns_attributes: [
            :id, :section_id, :created_at, :updated_at,
            fields_attributes: [
              :id, :column_id, :name, :fieldtype, :value, :required, :disabled, :glyphicon, :created_at, :updated_at,
              options_attributes: [
                :id, :field_id, :name, :created_at, :updated_at
              ]
            ]
          ]
        ]
      )
    end
end
