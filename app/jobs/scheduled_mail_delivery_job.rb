# Delivery job used by `ApplicationMailer` for all `deliver_later` sends.
#
# Every email provider enforces send limits (per-minute, hourly, and/or daily caps), and
# signals that a limit has been hit with a 4xx SMTP reply. Ruby's `Net::SMTP` raises every
# 4xx reply as `Net::SMTPServerBusy`, which gives us a single, provider-agnostic signal
# that we've been throttled.
#
# Rather than dropping the deletion request when we're throttled, we reschedule with
# back-off. Over 15 attempts this spans roughly a day and a half, which comfortably covers
# the hourly and daily windows providers use before their limits reset, so the batch drains
# out over time instead of failing.
class ScheduledMailDeliveryJob < ActionMailer::MailDeliveryJob
  retry_on Net::SMTPServerBusy, wait: :polynomially_longer, attempts: 15
end
