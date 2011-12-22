class UserMailer < ActionMailer::Base
  default from: "psdb@gsi.de"

  def welcome_email(user,password)
    @user = user
    @password=password
    @url  = "http://phpc048/login"
    mail(:to => user.email, :subject => "PHELIX shot database: Account registration")
  end
end
