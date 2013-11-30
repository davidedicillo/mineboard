json.array!(@servers) do |server|
  json.extract! server, :ip, :user, :password
  json.url server_url(server, format: :json)
end
