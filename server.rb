require 'sinatra'
require 'json'
require 'redis'

redis = Redis.new

post "/" do
  @power_on = params['power_on']
  @direction = params['direction']
  @power = params['power']
  redis.set("instructions-#{Time.now.to_i}", {power_on: @power_on, direction: @direction, power: @power}.to_json)
  redis.set("instructions-latest", {power_on: @power_on, direction: @direction, power: @power}.to_json)
end

get "/" do
  content_type :json
  redis.get('instructions-latest')
end