module Telegram
  class Notifier
    class Config
      attr_accessor :token, :chat_id

      def initialize
        @token   = nil
        @chat_id = nil
        # @token   = '665948096:AAG__1cxVUQ2MKjxCyjMhaoVVXmWfKM9RjY'
        # @chat_id = '-251286437'
      end
    end
  end
end
