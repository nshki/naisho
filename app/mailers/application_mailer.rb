class ApplicationMailer < ActionMailer::Base
  self.delivery_job = ScheduledMailDeliveryJob

  layout "mailer"
end
