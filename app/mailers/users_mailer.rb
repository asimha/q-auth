class UsersMailer < ActionMailer::Base

	default from: "q-auth@qwinixtech.com"

	def forgot_password(user)
		@user = user
		mail(:to=> @user.email, :subject=>"Reset your Q-Auth Password")
	end

end