# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Eightbitbacklog::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :port =>          '587',
  :address =>        'http://smtp.mandrillapp.com',
  :user_name =>      ENV['MANDRILL_USERNAME'],
  :password =>      ENV['MANDRILL_APIKEY'],
  :domain =>        'http://heroku.com',
  :authentication => :plain
}
