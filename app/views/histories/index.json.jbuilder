json.array!(@histories) do |history|
  json.extract! history, :id, :file
  json.url history_url(history, format: :json)
end
