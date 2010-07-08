# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  include AuthenticatedSystem
  
  # keine passwoerter in den log schreiben
  filter_parameter_logging :password
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_musicshare_session_id'
end
