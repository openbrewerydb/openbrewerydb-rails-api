# frozen_string_literal: true

# UUID Validator for Models
class UuidValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i

    msg = options[:message] || 'is not a valid UUID'
    record.errors.add(attribute, msg)
  end
end
