# Installation

````
docker-compose build
docker-compose run web rails db:create
docker-compose run web rails db:migrate
docker-compose up
aceess localhost:3000
````


# TODO

1. log機能

* 今日の新規追加、先週の追加、今月の追加

2. tag付加機能

3. preview機能

4. 本文検索

5. rss reader連動

## memo

````
redis = Redis.new(host: 'redis')

redis.keys.each {|k| redis.del k }
````
