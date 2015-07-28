module Api::V1 #:nodoc:
  class GroupsController < ApiController
    def index
    end

    def show
    	@group = Group.find(params[:id])
    end

    def create
      @group = Group.new(allowed_params)
      @group.save
      render 'show', status: 201
    end

    def update
      group = Group.find(params[:id])
      group.update_attributes(allowed_params)
      head :no_content
    end

    def destroy
      group = Group.find(params[:id])
      group.destroy
      head :no_content
    end

    private
      def allowed_params
        params.require(:group).permit(:name, :owner, :members, :templates)
      end
  end
end