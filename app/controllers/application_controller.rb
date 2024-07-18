class ApplicationController < ActionController::Base
  # Added this line to resetting session for requests without valid CSRF tokens.
  protect_from_forgery with: :null_session
end
