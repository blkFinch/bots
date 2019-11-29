require 'discordrb'
require 'rest-client'

file = File.read('secrets.json')
SECRETS = JSON.parse(file)


bot = Discordrb::Bot.new token: SECRETS["token"]

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Bong!'
end

bot.message(with_text: 'joke') do |event|
  response = JSON.parse(RestClient.get "http://jokes.guyliangilsing.me/retrieveJokes.php?type=dadjoke")
  event.respond response["joke"]
end

bot.mention() do |event|
  event.respond 'I heard my name'
end

bot.presence do |event|
  event.server.general_channel.send_message "#{event.user.name} has become #{event.user.status}!"
end

bot.run