class DeletionRequest::Validator < ActiveModel::Validator
  # Validates a `DeletionRequest`.
  #
  # @param record [DeletionRequest]
  # @return [void]
  def validate(record)
    validate_company_attached(record)
    validate_smtp_config_attached(record)
    validate_email_subject(record)
    validate_email_body(record)
  end

  private

  # Validates that a corresponding, valid `Company` object is attached.
  #
  # @param record [DeletionRequest]
  # @return [void]
  def validate_company_attached(record)
    if !record.company&.is_a?(Company) || record.company.invalid?
      record.errors.add(:company, I18n.t("models.deletion_request.company_missing"))
    end
  end

  # Validates that a corresponding, valid `SmtpConfig` object is attached.
  #
  # @param record [DeletionRequest]
  # @return [void]
  def validate_smtp_config_attached(record)
    if !record.smtp_config&.is_a?(SmtpConfig) || record.smtp_config.invalid?
      record.errors.add(:smtp_config, I18n.t("models.deletion_request.smtp_config_missing"))
    end
  end

  # Validates that the email subject is present.
  #
  # @param record [DeletionRequest]
  # @return [void]
  def validate_email_subject(record)
    if record.email_subject.blank?
      record.errors.add(:email_subject, I18n.t("models.deletion_request.email_subject_missing"))
    end
  end

  # Validates that the body has been edited to no longer contain placeholder copy.
  #
  # @param record [DeletionRequest]
  # @return [void]
  def validate_email_body(record)
    if record.email_body.blank?
      record.errors.add(:email_body, I18n.t("models.deletion_request.email_body.missing"))
    end

    if record.email_body&.include?(DeletionRequest::TOKENS[:full_name])
      record.errors.add(:email_body, I18n.t("models.deletion_request.email_body.full_name_missing"))
    end

    if record.email_body&.include?(DeletionRequest::TOKENS[:full_address])
      record.errors.add(:email_body, I18n.t("models.deletion_request.email_body.full_address_missing"))
    end

    if record.email_body&.include?(DeletionRequest::TOKENS[:email_addresses])
      record.errors.add(:email_body, I18n.t("models.deletion_request.email_body.email_addresses_missing"))
    end

    if record.email_body&.include?(DeletionRequest::TOKENS[:phone_numbers])
      record.errors.add(:email_body, I18n.t("models.deletion_request.email_body.phone_numbers_missing"))
    end

    if record.email_body&.include?(DeletionRequest::TOKENS[:signature_name])
      record.errors.add(:email_body, I18n.t("models.deletion_request.email_body.signature_name_missing"))
    end
  end
end
