# frozen_string_literal: true

# Read config/app.yml and config/app.example.yml and encrypted credentials.
class Config
  class << self
    def method_missing(method_name, *_args, &_block)
      result = hash[method_name.to_sym]
      result.is_a?(Hash) ? result.with_indifferent_access : result
    end

    def respond_to_missing?(method_name, _include_private = false)
      hash.key?(method_name.to_sym) || super
    end

    def set(key, value)
      hash[key.to_sym] = value
    end

    def hash
      @hash ||= app.merge(credentials)
    end
    alias :all :hash

    def credentials
      @credentials ||= Rails.application.credentials.config
    end

    def app
      @app ||= Rails.configuration.app
    end
  end
end
