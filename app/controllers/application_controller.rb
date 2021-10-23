# frozen_string_literal: true

# ApplicationController class
class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
end
