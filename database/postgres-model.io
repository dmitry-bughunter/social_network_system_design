// Репликация:
// - master-slave (async)
// - replication factor 2
//
// Шардинг:
//  feed, feed_item: key based by user_id
//  reaction: key based by post_id
//  location: key based by id
//  follow: key based by folowee_id
//
//  post: - не знаю, как зашардить эту таблицу, чтоб избежать кроссшардовых запросов.
// Мы выбираем из post n элементов ленты, а лента для каждого пользователя своя. Единственное, что приходит на ум - шардить по created_at,
// и сделать так чтобы feed_item.created_at = post.created_at.
// Среди n элементов feed_item найти самую старую дату и новую, и по этому диапазону определять нужный шард/шарды. Выглядит как костыль, но ничего пока не придумал лучше.


Table post_db.post {
  id uuid [pk]
  user_id uuid [not null, ref: > user_db.user.id]
  description varchar(1000)
  location_id uuid [ref: > location_db.location.id]
  photos text[]
  created_at timestamp [default: `current_timestamp`]
}

Table post_db.feed {
  id uuid [pk]
  user_id uuid [pk, not null, ref: > user_db.user.id]
  type varchar(30) [not null] // лента подписок, лента рекоммендаций
}

Table post_db.feed_item {
  feed_id uuid [pk, not null, ref: > post_db.feed.id]
  post_id uuid [pk, not null, ref: > post_db.post.id]
  created_at timestamp [default: `current_timestamp`]
}

Table post_db.reaction {
  post_id uuid [pk, not null, ref: > post_db.post.id]
  user_id uuid [pk, not null, ref: > user_db.user.id]
  rating smallint
  text varchar(300)
}

Table following_db.follow {
  follower_id uuid [pk, not null, ref: > user_db.user.id]
  followee_id uuid [pk, not null, ref: > user_db.user.id]
}

Table user_db.user {
  id uuid [pk]
  avatar_url text
  username varchar(100)
}

Table location_db.location {
  id uuid [pk]
  name varchar(255)
  description varchar(500)
  latitude GEOGRAPHY
  longitude GEOGRAPHY
}
