# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_planet_session',
  :secret => '6ed81c32c7d918b0167ce3d1cd6aeeff5747bfe83d35b08338c44487342de4e5819bb50acb80c3b657ae05a5ed60d0d86ce23593c212cabf88e589ac6307f044'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
