module Api::V1#:nodoc:
  class TemplatesController < ApiController

    nested_attributes_names = Template.nested_attributes_options.keys.map do |key|
      key.to_s.concat('_attributes').to_sym
    end
    wrap_parameters include: Template.attribute_names + nested_attributes_names

    def index

      queried_templates = if params.has_key?(:keywords)

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

      if params.has_key?(:ts)
        render json: queried_templates.where(:draft => [nil,'f']).where.not(:id => params[:ts][1..-2].split(',').collect! {|n| n.to_i}).index_minned
      else
        render json: queried_templates.page(params[:page]).per(10).order(id: :desc).index_minned
      end

    end

    def show
      @template = current_user.templates.find(params[:id])
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
      template.update_attributes(allowed_params)
      current_user.templates << template unless current_user.templates.include?(template)
      head :no_content
    end

    def destroy
      template = current_user.templates.find(params[:id])
      if template.destroy
        head :no_content
      else
        render json: { errors: 'A page may not be deleted while a report is using it.' }, status: 422
      end
    end

    private
      def allowed_params
        params.require(:template).permit(
          :name, :draft, :private_group, :private_world, :group_id, :group_edit, :group_editors,
          {:sections => []},
          {:fields_attributes => [
            :id, :fieldtype, {:o => [
              :section_id, :column_id, :column_order, :name, :placeholder, :tooltip, :required, :disabled, :glyphicon, :default_value, {:options => []}
            ]}
          ]}
        )
      end
  end
end
