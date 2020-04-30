require 'telegram-notifier/client'
require 'telegram-notifier/config'
require 'telegram-notifier/version'

module Telegram
  class Error < StandardError; end

  class Notifier
    class << self
      attr_writer :config

      def config
        @config ||= Config.new
      end

      # Telegram::Notifier.configure { |config| config.token = 'XXXX' }
      def configure
        yield(config)
      end

      def ping(message, options = {})
        new(options.delete(:chat_id)).ping(message, options)
      end
    end

    attr_reader :chat_id

    def initialize(chat_id = nil)
      @chat_id = chat_id
    end

    # reply_markup: {"inline_keyboard":[[{"text":"button","url":"https://www.yahoo.co.jp/"}]]}.to_json
    def ping(message, options = {})
      if message.is_a?(Hash)
        options = message
      else
        options[:text] = message
      end

      params = build_params(options)
      Client.post(endpoint, params)
    end

    private

    def build_params(options)
      options[:chat_id] = chat_id || self.class.config.chat_id

      options.each_with_object({}) do |(key, val), params|
        params[key] = val.is_a?(Hash) ? val.to_json : val
      end
    end

    def endpoint
      "https://api.telegram.org/bot#{self.class.config.token}/sendMessage"
    end
  end
end
