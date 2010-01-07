# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_no-hablo_session',
  :secret      => 'e5bdaa6351b47b8898173e828cae8d582f730f464f9ebdfcf2fd8a4e8989d8691591cd5105442a01945b2ea65d39fe975a1dd7a810576437f2c251217e08193a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
