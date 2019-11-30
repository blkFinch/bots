require 'discordrb'
require 'rest-client'

file = File.read('secrets.json')
SECRETS = JSON.parse(file)

key = SECRETS["api-key"]
bot = Discordrb::Bot.new token: SECRETS["token"]

# Clan Group Id: 4027993
CLAN_ID = 4027993

URL = "http://www.bungie.net/Platform"

# TEMPLATE FOR REST Request
# response = RestClient.get( 
#   url, 
#   request,
#   :content_type => :json, :accept => :json, :'x-auth-key' => "mykey")

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Bong!'
end

bot.message(with_text: 'joke') do |event|
  response = JSON.parse(RestClient.get "http://jokes.guyliangilsing.me/retrieveJokes.php?type=dadjoke")
  event.respond response["joke"]
end

bot.message(with_text: 'api') do |event|
  response = JSON.parse(RestClient.get( 
    "http://www.bungie.net/Platform/Destiny2/Clan/#{CLAN_ID}/WeeklyRewardState/", 
    'x-api-key' => key))
  milestone = response["Response"]["milestoneHash"]
  clan_milestone = JSON.parse(RestClient.get(
    "http://www.bungie.net/Platform/Destiny2/Milestones/#{milestone}/Content/",
    'x-api-key' => key))
  event.server.general_channel.send_message "Clan milestone: #{clan_milestone}"
end

bot.message(with_text: 'roll call') do |event|
  response = JSON.parse(RestClient.get( 
    URL + "/GroupV2/#{CLAN_ID}/Members/", 
    'x-api-key' => key))
  members = response["Response"]["results"]
  members.each do |member|
    event.server.general_channel.send_message "#{member["destinyUserInfo"]["displayName"]}"
  end
end

bot.mention() do |event|
  event.respond 'I heard my name'
end

bot.presence do |event|
  event.server.general_channel.send_message "#{event.user.name} has become #{event.user.status}!"
end

bot.run
