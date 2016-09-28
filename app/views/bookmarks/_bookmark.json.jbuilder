json.extract! bookmark, :id, :title, :href, :body, :created_at, :updated_at
json.url bookmark_url(bookmark, format: :json)