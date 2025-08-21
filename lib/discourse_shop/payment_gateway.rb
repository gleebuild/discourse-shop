
# frozen_string_literal: true
module DiscourseShop
  class PaymentResult
    attr_reader :provider, :pay_url, :payload
    def initialize(provider:, pay_url:, payload: {})
      @provider = provider
      @pay_url = pay_url
      @payload = payload
    end
  end

  module PaymentGateway
    @providers = {}
    def self.register(name, klass); @providers[name.to_s] = klass; end
    def self.available; @providers.keys; end
    def self.resolve(name); @providers[name.to_s]; end

    class SandboxProvider
      def self.create_payment(order:, return_url:, notify_url: nil, ip: nil, ua: nil)
        order.update_columns(status: DiscourseShop::Order.statuses[:paid], paid_at: Time.now)
        DiscourseShop::Log.log!("[sandbox] order ##{order.id} auto-paid")
        PaymentResult.new(provider: 'sandbox', pay_url: return_url, payload: { order_id: order.id })
      end
    end
  end

  PaymentGateway.register('sandbox', PaymentGateway::SandboxProvider)
end
