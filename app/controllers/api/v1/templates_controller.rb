module Api::V1#:nodoc:
  class TemplatesController < ApiController
    nested_attributes_names = Template.nested_attributes_options.keys.map do |key|
      key.to_s.concat('_attributes').to_sym
    end
    wrap_parameters include: Template.attribute_names + nested_attributes_names

    def index
      max_per_page = 5

      pre_paginated_templates = if params.has_key?(:keywords)

        keywords = params[:keywords]
        
        query = if keywords.to_i > 0
          {:id => keywords.to_i}
        elsif keywords.capitalize == 'Draft'
          {:draft => 't'}
        else
          {:name => keywords}
        end
        current_user.templates.where(query)
      else
        current_user.templates
      end

      if params.has_key?(:d)
        pre_paginated_templates = pre_paginated_templates.where(:draft => [nil,'f'])
      end

      if params.has_key?(:ts)
        pre_paginated_templates = pre_paginated_templates.where.not(:id => params[:ts][1..-2].split(',').collect! {|n| n.to_i})
      end

      paginate pre_paginated_templates.count, max_per_page do |limit, offset|
        render json: pre_paginated_templates.order(id: :desc).limit(limit).offset(offset).index_minned
      end
    end

    def show
      template = current_user.templates.find(params[:id])
      render json: template.show_minned
    end

    def create
      @template = current_user.templates.new(allowed_params)
      @template.save
      current_user.templates << @template
      render 'show', status: 201
    end

    def update
      template = current_user.templates.find(params[:id])
      template.sections = params[:sections]
      template.columns = params[:columns]
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
          :name, :creator_uid, :sections, :columns, :private_group, :private_world, :group_id, :group_edit, :group_editors, :draft,
          fields_attributes: [
            :id, :name, :fieldtype, :required, :disabled, :glyphicon, :section_id, :column_id,
            values_attributes: [
              :id, :input
            ],
            options_attributes: [
              :id, :name
            ]
          ]
        )
      end
  end
end