module Api::V1 #:nodoc:
  class SectionsController < ApiController
    nested_attributes_names = Section.nested_attributes_options.keys.map do |key|
      key.to_s.concat('_attributes').to_sym
    end
    wrap_parameters include: Section.attribute_names + nested_attributes_names
    
    def show
    end

    def create
      template = current_user.templates.find(params[:template_id])
      @section = template.sections.new(allowed_params)
      @section.save
      render 'show', status: 201
    end

    def update
      section = Section.find(params[:id])
      section.update(allowed_params)
      head :no_content
    end

    def destroy
      section = Section.find(params[:id])
      section.destroy
      head :no_content
    end

    private
      def allowed_params
        params.require(:section).permit(:name)
      end
  end
end