require 'rubygems'
require 'redis'
require 'byebug'

@redis = Redis.new(host: 'redis', timeout: 0)

@redis.subscribe("irvine-ppe") do |on|
  on.message do |channel, msg|
    puts "Msg Received: #{channel} | #{msg}"
  end
end
