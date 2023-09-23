require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UrbanLamp
  class Application < Rails::Application
    config.load_defaults 7.0

    config.eager_load_paths << Rails.root.join('lib')
    config.middleware.use ActionDispatch::Cookies
    config.session_store :cookie_store, key: '_interslice_session'

    config.middleware.use config.session_store, config.session_options

    config.time_zone = 'Rome'

    config.active_record.default_timezone = :utc
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :en
    config.i18n.available_locales = %i[it en]

    config.app = config_for("app.example").symbolize_keys
    if File.exist?("config/app.yml")
      config.app.merge!(config_for("app").symbolize_keys)
    end

    smtp = Rails.configuration.app[:smtp]
    imap = Rails.configuration.app[:imap]
    Mail.defaults do
      if imap
        retriever_method :imap, :address        => imap[:address],
                                :port           => imap[:port],
                                :user_name      => imap[:user_name],
                                :password       => imap[:password],
                                :enable_ssl     => imap[:enable_ssl]
      end

      if smtp
        delivery_method :smtp, :address         => smtp[:address],
                                :port           => smtp[:port],
                                :authentication => smtp[:authentication],
                                :password       => smtp[:password],
                                :user_name      => smtp[:user_name]
      end
    end

    smtp = Rails.configuration.app[:smtp]

    if smtp
      config.action_mailer.delivery_method = :smtp
      config.action_mailer.smtp_settings = smtp
    end

    Rails.application.routes.default_url_options[:host] = Rails.configuration.app[:base_url]

    config.hosts = Rails.configuration.app[:origins]

    config.active_job.queue_adapter = :sidekiq

    config.api_only = true
  end
end
