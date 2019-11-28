require 'discordrb'

file = File.read('secrets.json')
SECRETS = JSON.parse(file)


bot = Discordrb::Bot.new token: SECRETS["token"]

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Bong!'
end

bot.run