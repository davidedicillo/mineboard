json.array!(@stats) do |stat|
  json.extract! stat, 
  json.url stat_url(stat, format: :json)
end
