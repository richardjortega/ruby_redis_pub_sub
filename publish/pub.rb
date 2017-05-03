# usage:
# ruby pub.rb channel username

require 'rubygems'
require 'redis'
require 'json'
require 'byebug'
require 'awesome_print'

redis = Redis.new(host: 'redis')

key = "irvine-ppe"
count = 0

loop do
  msg = "hello JC!"
  puts "Sending message: #{msg}"
  redis.publish key, msg
  count += 1
  sleep 2
end
