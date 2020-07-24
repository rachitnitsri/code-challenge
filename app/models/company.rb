class Company < ApplicationRecord

  EMAIL_VALIDATOR_REGEX = /\b([a-z0-9_\.-]+)@getmainstreet.com\z/

  has_rich_text :description
  validate :email_validations

  def email_validations
    if self.email.present? && !self.email.match(EMAIL_VALIDATOR_REGEX)
      errors.add(:email, "Provided email address must end with @getmainstreet.com domain")   # for rendering custom error
    end
  end

end
