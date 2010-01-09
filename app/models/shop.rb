class Shop < ActiveRecord::Base
  has_many :translations

  validates_presence_of :site, :subdomain

  # The reason that we use the subdomain as the unique identifier for a Shop, instead of
  # using the ActiveResource site value, is that the site value could change. If a shop were
  # to revoke access to your application and re-install it at a later date, it would get
  # a new password for your app and its site would change. It's subdomain however is 
  # immutable and makes a better key for Shops.
  validates_uniqueness_of :subdomain
end
