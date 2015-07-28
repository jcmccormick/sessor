module Api::V1 #:nodoc:
  class OptionsController < ApiController
    def show
    end

    def create
      field = Field.find(params[:field_id])
      @option = field.options.new(allowed_params)
      @option.save
      render 'show', status: 201
    end

    def update
      option = Option.find(params[:id])
      option.update(allowed_params)
      head :no_content
    end

    def destroy
      option = Option.find(params[:id])
      option.destroy
      head :no_content
    end

    private
      def allowed_params
        params.require(:option).permit(:name)
      end
  end
end