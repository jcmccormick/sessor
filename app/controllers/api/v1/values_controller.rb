module Api::V1 #:nodoc:
  class ValuesController < ApiController

    def index
      if params.has_key?(:stats)
        values = current_user.values.where(:field_id => params[:field_id]).as_json(only: [:input, :created_at])
        render json: values
      end
    end

    def show
    end

    def create
      field = Field.find(params[:field_id])
      @value = field.values.new(allowed_params)
      @value.save
      render 'show', status: 201
    end

    def update
      value = Value.find(params[:id])
      value.update(allowed_params)
      head :no_content
    end

    def destroy
      value = Value.find(params[:id])
      value.destroy
      head :no_content
    end

    private
      def allowed_params
        params.require(:value).permit(:input)
      end
  end
end