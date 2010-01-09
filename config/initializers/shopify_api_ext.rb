module ShopifyAPI
  class Session
    def subdomain
      @url.split('.').first
    end
  end
  
  class Base
    def self.find_each(options = {})
      find_in_batches(options) do |records|
        records.each { |record| yield record }
      end

      self
    end

    def self.find_in_batches(options = {})
      page = 1
      limit = options.delete(:limit) || 100

      objects = find(:all, :params => {:page => page, :limit => limit})

      while objects.any?
        yield objects

        break if objects.size < limit
        page += 1
        objects = find(:all, :params => {:page => page, :limit => limit})
      end
    end
  end
end
