# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'info@openbrewerydb.org'
  layout 'mailer'
end
