class ContactsController < ApplicationController

	def create
		Contact.create(allowed_params)
		head :no_content
	end

	private
		def allowed_params
			params.require(:contact).permit(:email, :message)
		end

end