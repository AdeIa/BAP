class AdminMailer < ApplicationMailer
	 default from: ENV['gmail_username'] # for library
	 default to: ENV['gmail_username'] # for admin

	 def new_user_waiting_for_approval(email)
	 	mail(to: email, subject: 'Do aplikace se zaregistroval novy ctenar')
	 end

end
