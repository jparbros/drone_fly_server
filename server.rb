require 'sinatra'
require 'json'
require 'redis'

set :logging, true
set :environment, :production

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
  power_on = JSON.parse(redis.get('instructions-latest'))['power_on']
  if power_on == '1'
    redis.get('instructions-latest')
  else
    {power_on: 0, direction: 0, power: 0}.to_json
  end
  
end