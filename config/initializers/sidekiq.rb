#Sidekiq.configure_server do |config|
#  config.redis = { url: 'redis://redis:6379', namespace: 'sidekiq' }
#end
#Sidekiq.configure_server do |config|
#  config.redis = { url: "redis://#{ENV['REDIS_PORT_6379_TCP_ADDR']}:#{ENV['REDIS_PORT_6379_TCP_PORT']}/0", namespace: 'sidekiq' }
#end
#
#Sidekiq.configure_client do |config|
#  config.redis = { url: "redis://#{ENV['REDIS_PORT_6379_TCP_ADDR']}:#{ENV['REDIS_PORT_6379_TCP_PORT']}/0", namespace: 'sidekiq' }
#end
#
## jobをキューにためるのに必要
Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

## jobをキューから取得するのに必要
Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end
