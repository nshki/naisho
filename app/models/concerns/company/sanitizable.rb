module Company::Sanitizable
  extend ActiveSupport::Concern

  included do
    before_save :strip_name!
    before_save :domainify_website!
    before_save :downcase_email!
  end

  # Ensures we're stripping leading and trailing whitespace from the name.
  #
  # @return [void]
  def strip_name!
    name.strip!
  end

  # Ensures we're only saving website domains to better enforce uniqueness.
  #
  # @return [void]
  def domainify_website!
    hostified_website = URI(website).host || website
    self.website = hostified_website.gsub(/^www\./, "")
  end

  # Ensures we're normalizing emails before saving.
  #
  # @return [void]
  def downcase_email!
    email.downcase!
  end
end
