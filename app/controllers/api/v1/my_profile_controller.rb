module Api
  module V1
    class MyProfileController < Api::V1::BaseController
      def my_profile
        proc_code = Proc.new do
          @data = @current_user
        end
        render_json_response(proc_code)
      end

      def update

        proc_code = Proc.new do

          @user = current_user
          @user.assign_attributes(user_params)
          if params[:user][:designation]
            designation = Designation.find_by_title(params[:user][:designation])
            @user.designation = designation if designation
          end
          if params[:user][:department]
            department = Department.find_by_name(params[:user][:department])
            @user.department = department if department
          end
          @user.password = params[:user][:password] if params[:user][:password]
          @user.password_confirmation = params[:user][:password_confirmation] if params[:user][:password_confirmation]

          if @user.valid?
            @user.save
            @data = @user
            @alert = I18n.translate("registration.success")
          else
            @success = false
            @alert = I18n.translate("response.validation_error")
            @errors = @user.errors
            raise ValidationError
          end
        end
        render_json_response(proc_code)
      end

      def user_params
        params.require(:user).permit(:name, :username, :phone, :skype, :linkedin, :city, :state, :country, :biography, :designation_overridden, :password, :password_confirmation)
      end
    end
  end
end
