class TemplatesController < ApplicationController
  devise_token_auth_group :member, contains: [:user, :admin]
  before_action :authenticate_member!

  skip_before_filter :verify_authenticity_token

  nested_attributes_names = Template.nested_attributes_options.keys.map do |key|
    key.to_s.concat('_attributes').to_sym
  end
  wrap_parameters include: Template.attribute_names + nested_attributes_names

  def index
    max_per_page = 5

    paginate current_user.templates.count, max_per_page do |limit, offset|
      render json: current_user.templates.limit(limit).offset(offset).to_json(
      :include => { :sections => {
        :include => { :columns => {
          :include => { :fields => {
            :include => [:options, :values]
          }}
        }}
      }}
    )
    end
  end

  def show
    render json: current_user.templates.find(params[:id]).as_json(
      :include => { :sections => {
        :include => { :columns => {
          :include => { :fields => {
            :include => [:options, :values]
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
        :name, :creator_uid, :private_world, :private_group, :group_id, :group_edit, :group_editors, :allow_title, :draft, 
        sections_attributes: [
          :id, :name,
          columns_attributes: [
            :id,
            fields_attributes: [
              :id, :name, :fieldtype, :required, :disabled, :glyphicon,
              values_attributes: [
                :id, :input
              ],
              options_attributes: [
                :id, :name
              ]
            ]
          ]
        ]
      )
    end
end
