# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
secret_key_base = 'c3a62b6e2236d66db4f1213324eb87df2889765d0b12c67ccb272c7c56f2d56b4ed07200100058aeb5f4d0ee94ea9cab8bad2044f21cac59b58dfb78f2886238'
if Rails.gem_version >= Gem::Version.new('5')
  Dummy::Application.config.secret_key_base = secret_key_base
else
  Dummy::Application.config.secret_token = secret_key_base
end
