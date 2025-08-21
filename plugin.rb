
# frozen_string_literal: true
# name: discourse-shop
# about: Mall plugin with SSR fallback, detailed logging, pluggable payments
# version: 1.0.0
# authors: GleeBuild + ChatGPT
# required_version: 3.0.0

enabled_site_setting :shop_enabled
register_asset 'stylesheets/common/discourse-shop.scss'

after_initialize do
  module ::DiscourseShop
    PLUGIN_NAME = "discourse-shop"
    module Log
      def self.log!(message)
        if defined?(::DiscourseWechatHomeLogger)
          ::DiscourseWechatHomeLogger.log!(message)
        else
          begin
            dir = "/var/www/discourse/public"
            file = File.join(dir, "mall.txt")
            FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
            timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S %z")
            File.open(file, "a") { |f| f.puts("#{timestamp} | #{message}") }
          rescue => e
            Rails.logger.warn("[shop-log] write error: #{e.class}: #{e.message}")
          end
        end
      end
    end
  end

  require_relative 'lib/discourse_shop/engine'
  require_relative 'lib/discourse_shop/payment_gateway'
  require_relative 'app/controllers/discourse_shop/spa_controller'

  Rails.logger.info('[shop] plugin booting...')
  DiscourseShop::Log.log!('[shop] plugin booting...')

  Discourse::Application.routes.append do
    mount ::DiscourseShop::Engine, at: '/shop-api'
    get '/shop' => 'discourse_shop/spa#index'
    get '/shop/admin' => 'discourse_shop/spa#index'
    get '/shop/*anything' => 'discourse_shop/spa#index'
  end

  Rails.logger.info('[shop] routes mounted (api:/shop-api, spa:/shop)')
  DiscourseShop::Log.log!('[shop] routes mounted (api:/shop-api, spa:/shop)')
end
