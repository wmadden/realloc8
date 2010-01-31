# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_realloc8_session',
  :secret      => 'bcbc805056b3e371147077e9494878551d10495c5128d86ba2da2eafae01640642f32762932c6c8f90364be393c8e048f633344b491c5a9ebf8d3f59df0ae758'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
