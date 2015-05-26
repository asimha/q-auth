module Api
  module V1
    class AuthenticationsController < Api::V1::BaseController

      skip_before_filter :require_auth_token, :only => [:create]

      def create
        proc_code = Proc.new do
          @registration_details = AuthenticationService.new(params)
          if @registration_details.error
            set_notification_messages(@registration_details.error, :error)
            raise InvalidLoginError
          else
            @current_user = @data = @user = @registration_details.user
            @success = true
            set_notification_messages("authentication.logged_in", :success)
          end
        end
        render_json_response(proc_code)
      end

      def destroy
        proc_code = Proc.new do
          set_notification_messages("authentication.logged_out", :success)
          @current_user.end_session
        end
        render_json_response(proc_code)
      end
    end
  end
end
