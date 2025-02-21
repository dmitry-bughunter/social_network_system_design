#### Для хранения изображений постов используем какое-нибудь S3 хранилище.

```
s3://trs-bucket/
    users/
        {user_id}/
            posts/
                {post_id}/
                    images/
                        image1.jpg
                        image2.jpg
                        ... 
```