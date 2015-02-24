json.array!(@hooks) do |hook|
  json.extract! hook, :id
  json.url hook_url(hook, format: :json)
end
