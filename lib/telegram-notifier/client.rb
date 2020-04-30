require 'net/http'
require 'json'

module Telegram
  class Notifier
    class APIError < StandardError; end

    class Client
      def self.post(uri, params)
        new(uri, params).call
      end

      attr_reader :uri, :params

      def initialize(uri, params)
        @uri    = URI.parse(uri)
        @params = params
      end

      def call
        res = http.start { |conn| conn.request(req) }

        case res
        when Net::HTTPSuccess
          JSON.parse(res.body)
        else
          raise Telegram::Notifier::APIError, <<~MSG
            The telegram API returned an error: #{res.body} (HTTP Code #{res.code})
            Check the "Error handling" section on https://core.telegram.org/api/errors for more information
          MSG
        end
      end

      private

      def http
        httq = Net::HTTP.new(uri.host, uri.port)

        if uri.port == 443
          httq.use_ssl = true
          httq.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        httq
      end

      def req
        rep = Net::HTTP::Post.new(uri)
        rep.form_data = params
        rep
      end
    end
  end
end
