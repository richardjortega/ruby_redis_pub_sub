require 'rubygems'
require 'redis'
require 'json'
require 'byebug'

$redis = Redis.new(timeout: 0)

$redis.subscribe("B016005991000520", "B016005991000520.c2") do |on|
  on.message do |channel, msg|
    data = JSON.parse(msg)
    puts "Msg Received: #{channel} | #{data}"
  end
end
