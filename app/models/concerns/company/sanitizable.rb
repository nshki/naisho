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

  # Ensures we're only saving website domains to better enforce uniqueness. This
  # effectively means we're not storing HTTP, HTTPS, or `www`. We're also doing
  # a regex extraction to account for incorrectly formatted URLs from third-party
  # sources.
  #
  # @return [void]
  def domainify_website!
    stripped_website = website.strip
    extracted_website = stripped_website.scan(/[\w|\d\.]+/).last
    hostified_website = URI(extracted_website).host || extracted_website || stripped_website
    self.website = hostified_website.gsub(/^www\./, "")
  end

  # Ensures we're normalizing emails before saving.
  #
  # @return [void]
  def downcase_email!
    self.email = email.strip.downcase
  end
end
