class ApplicationMailer < ActionMailer::Base
  default from: "joe@clerkr.com"
  layout 'mailer'
end