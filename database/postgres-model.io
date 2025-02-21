Table location {
  id uuid [pk]
  name varchar(255)
  description varchar(500)
  latitude GEOGRAPHY
  longitude GEOGRAPHY
}

Table post {
  id uuid [pk]
  user_id uuid [not null, ref: > user.id]
  description varchar(1000)
  location_id uuid [ref: > location.id]
  photos text[]
  created_at timestamp [default: `current_timestamp`]
}

Table follow {
  follower_id uuid [pk, not null, ref: > user.id]
  followee_id uuid [pk, not null, ref: > user.id]
}

Table feed {
  id uuid [pk]
  user_id uuid [pk, not null, ref: > user.id]
  type varchar(30) [not null] // лента подписок, лента рекоммендаций
}

Table feed_item {
  feed_id uuid [pk, not null, ref: > feed.id]
  post_id uuid [pk, not null, ref: > post.id]
  created_at timestamp [default: `current_timestamp`]
}

Table reaction {
  post_id uuid [pk, not null, ref: > post.id]
  user_id uuid [pk, not null, ref: > user.id]
  rating smallint
  text varchar(300)
}

Table user {
  id uuid [pk]
  avatar_url text
  username varchar(100)
}
