# frozen_string_literal: true

module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end
end
