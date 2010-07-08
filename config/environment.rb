# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when you don't control
# web/app server and can't set it the proper way #ENV['RAILS_ENV'] ||=
# 'development'

ENV['RAILS_ENV'] ||= 'development'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# MusicShare Constants

EMAIL			= 'feenyl@gmail.com'
MAX_USERS	= 20
DAYS_TO_REMEMBER = 20			  #you are a lazy user after 20 days
MAX_FILESIZE	  = 10000 * 1024
URL				  = "http://diewg.isa-geek.net:8080"
URL_NEW			  = "http://feenyl.servemp3.com/"


if ENV['RAILS_ENV'] == 'production'
  ENCLOSURE_PATH = "/htdocs/musicshare/rails/public/feed/uploaded/"
  REMOVE_REWRITE = "/htdocs/musicshare/rails/public"
  DIGEST			= "/var/safe/digest_passwd"
  FEED_PATH	   = "/htdocs/musicshare/rails/public/feed/rss.xml"
  DAYS_TO_WAIT   = 7
	 
else
  ENCLOSURE_PATH = "public/feed/uploaded/"
  REMOVE_REWRITE = ""
  DIGEST			= "safe/digest_passwd"
  FEED_PATH		= "public/feed/rss.xml"
  DAYS_TO_WAIT   = 0
end

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here

  # mach das weil es die fehlermeldung sagt
  config.action_controller.session = { :session_key => "_myapp_session", :secret => "some secret phrase of at least 30 characters" }

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins
  # are loaded config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs config.load_paths += %W(
  # #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level (by default production
  # uses :info, the others :debug) config.log_level = :debug

  # Use the database for sessions instead of the file system (create the session
  # table with 'rake db:sessions:create') config.action_controller.session_store
  # = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test
  # database. This is necessary if your schema can't be completely dumped by the
  # schema dumper, like if you have constraints or database-specific column
  # types config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => "localhost",
  :authentication => :plain,
  :user_name => "feenyl",
  :password => "hugendubel"
}



# Add new inflection rules using the following format (all these examples are
# active by default): Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks: Mime::Type.register
# "text/richtext", :rtf Mime::Type.register "application/x-mobile", :mobile

# Include your application configuration below