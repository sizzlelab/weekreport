# Be sure to restart your server when you modify this file.

Weekreport::Application.config.session_store :cookie_store, :key => '_weekreport_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# Weekreport::Application.config.session_store :active_record_store


# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.

# Will use the secert found in the file if exists. Otherwise generate new and store.

secret_file = File.join(Rails.root.to_s, "config/session_secret")
if File.exist?(secret_file)
  secret = File.read(secret_file)
else
  secret = ActiveSupport::SecureRandom.hex(64)
  File.open(secret_file, 'w') { |f| f.write(secret) }
end

Rails.application.config.secret_token = secret
