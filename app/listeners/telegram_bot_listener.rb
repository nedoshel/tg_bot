require "telegram/bot"

class TelegramBotListener
  def initialize
      token = Rails.application.credentials.telegram_token
      @bot = Telegram::Bot::Client.new(token)
  end

  def run_telegram_bot
    @bot.run do |bot|
      bot.listen do |message|
        case message
        when Telegram::Bot::Types::Message
          case message.text
          when "/start"
            user_full_name = "#{message.from.first_name} #{message.from.last_name}"
            @bot.api.send_message(chat_id: message.from.id, text: "Hello #{user_full_name} , пёс")

            reply_buttons = [ [ { text: "/generate_reply" } ], [ { text: "/generate_inline" } ] ]
            reply_buttons_markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: reply_buttons, resize_keyboard: true)
            @bot.api.send_message(chat_id: message.from.id, text: "Here are your reply buttons", reply_markup: reply_buttons_markup)
          when "/generate_reply"
            reply_buttons = [ [ { text: "Say Hi" } ], [ { text: "Say Bye" } ] ]
            reply_buttons_markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: reply_buttons, resize_keyboard: true)
            @bot.api.send_message(chat_id: message.from.id, text: "Here are your reply buttons", reply_markup: reply_buttons_markup)
          when "/generate_inline"
            inline_buttons = [
              [ Telegram::Bot::Types::InlineKeyboardButton.new(text: "Youtube Link", url: "https://www.youtube.com/") ],
              [ Telegram::Bot::Types::InlineKeyboardButton.new(text: "Link with callback", callback_data: "I am callback data") ]
            ]
            inline_buttons_markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: inline_buttons, resize_keyboard: true)
            @bot.api.send_message(chat_id: message.from.id, text: "Here are your inline buttons", reply_markup: inline_buttons_markup)
          end
        end
      end
    end
  end
end
