class ApplicationMailer < ActionMailer::Base
  default from: ENV['gmail_username']
  layout 'mailer'

  	def unapproved_user(email)
	    mail(to: email, subject: 'Neschvaleni registrace')
	end

	def user_was_approved(email)
	    mail(to: email, subject: 'Schvaleni registrace')
	end	

	def destroy_user(email)
	    mail(to: email, subject: 'Smazani ctenarskeho uctu')
	end

	def update_user(email, changes)
		mail(to: email, subject: 'Knihovnik upravil Vase ctenarske konto')
	end

	def loan_reminder(email,books)
		@books = books
		mail(to: email, subject: 'Blizi se datum vraceni vypujcek')
	end
end
