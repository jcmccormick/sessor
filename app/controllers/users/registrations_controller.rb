class Users::RegistrationsController < DeviseTokenAuth::RegistrationsController

    def account_update_params
        params.require(:registration).permit(:googler)
    end
end