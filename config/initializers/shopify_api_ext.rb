module ShopifyAPI
  class Session
    def subdomain
      @url.split('.').first
    end
  end
end
