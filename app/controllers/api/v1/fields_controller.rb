module Api::V1 #:nodoc:
  class FieldsController < ApiController
    nested_attributes_names = Field.nested_attributes_options.keys.map do |key|
      key.to_s.concat('_attributes').to_sym
    end
    wrap_parameters include: Field.attribute_names + nested_attributes_names
    
    def index
      if params.has_key?(:stats)
        render json: current_user.fields.only(['fields.id', 'fields.name']).where(:template_id => params[:template_id]).where.not(:fieldtype => 'labelntext').uniq { |f| f.id }
      end
    end

    def show
    end

    def create
      template = Template.find(params[:template_id])
      @field = template.fields.new(allowed_params)
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
        params.require(:field).permit(:section_id, :column_id, :column_order, :name, :fieldtype, :required, :disabled, :glyphicon)
      end
  end
end