/* TOP 5 OLDEST USER: */

SELECT username, created_at FROM users
ORDER BY created_at
LIMIT 5;

/* Inactive Users */

SELECT DISTINCT username FROM users
WHERE id NOT IN (SELECT DISTINCT user_id FROM photos);

/* User having most liked photo */

SELECT users.id,users.username,likes.photo_id, COUNT(likes.user_id) AS total_likes,photos.created_dat as post_date,photos.image_url
FROM likes JOIN photos
ON photos.id=likes.photo_id
JOIN users
ON photos.user_id=users.id
GROUP BY likes.photo_id
ORDER BY total_likes DESC
LIMIT 1;

/* Most Used Hashtags */

SELECT COUNT(photo_tags.photo_id) as num_photos, photo_tags.tag_id,tags.tag_name
FROM photo_tags JOIN  tags ON photo_tags.tag_id=tags.id
GROUP BY tag_id
ORDER BY num_photos DESC
LIMIT 5;

/*  Day most users registered */

SELECT COUNT(username) as no_users, DAYOFWEEK(created_at) as day_num
FROM users
GROUP BY day_num
ORDER BY no_users DESC;

/* Average posts on instagram */

SELECT u.total_users, p.total_photos, p.total_photos/u.total_users AS avg_posts FROM
(SELECT COUNT(id) AS total_users FROM users u) AS u
CROSS JOIN
(SELECT COUNT(id) AS total_photos FROM photos P) AS p;

/* Bot accounts */

SELECT likes.user_id, COUNT(likes.photo_id) AS posts_liked,users.username,users.created_at 
FROM likes JOIN users
ON users.id=likes.user_id
GROUP BY user_id
HAVING posts_liked=(SELECT MAX(id) FROM photos);
