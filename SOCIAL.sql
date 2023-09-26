DROP DATABASE IF EXISTS SOCIAL;
CREATE DATABASE SOCIAL;
USE SOCIAL;

CREATE TABLE Users(
user_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
email VARCHAR(255) NOT NULL UNIQUE,
username VARCHAR(25) NOT NULL UNIQUE,
pass VARCHAR(255) NOT NULL,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255) NOT NULL,
gender ENUM('M', 'F'),
birth_date DATE,
age INT,
date_created DATE NOT NULL,
active_status ENUM('yes','no') NOT NULL DEFAULT 'no'
);
SELECT * FROM Users;
DROP TABLE Users;

CREATE TABLE Posts(
post_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id int NOT NULL,
caption  VARCHAR(255),
content ENUM('image', 'video'),
post_url VARCHAR(255) NOT NULL,
date_posted DATE NOT NULL,
FOREIGN KEY (user_id) 
REFERENCES Users(user_id)
ON DELETE CASCADE
);

SELECT * FROM Posts;
DROP TABLE POSTS;

CREATE TABLE Followers(
request_sender_id INT NOT NULL UNIQUE, 
request_acceptor_id INT NOT NULL UNIQUE, 
date_created DATE NOT NULL,
PRIMARY KEY (request_sender_id,request_acceptor_id),
FOREIGN KEY (request_acceptor_id) REFERENCES Users(user_id),
FOREIGN KEY (request_sender_id) REFERENCES Users(user_id)
);

SELECT * FROM Followers;
DROP TABLE Followers;

CREATE TABLE Comments(
comment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
post_id INT NOT NULL,
user_id INT NOT NULL,
content TEXT NOT NULL,
date_created DATE NOT NULL,
FOREIGN KEY (post_id) REFERENCES Posts(post_id),
FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

SELECT * FROM Comments;
DROP TABLE COMMENTS;

CREATE TABLE Messages(
message_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
user_id_from INT NOT NULL,
user_id_to INT NOT NULL,
content text NOT NULL,
date_sent date NOT NULL,
FOREIGN KEY (user_id_from) REFERENCES Users(user_id),
FOREIGN KEY (user_id_to) REFERENCES Users(user_id)
);

SELECT * FROM Messages;
DROP TABLE MESSAGES;

CREATE TABLE Friends(
request_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
req_sent_from INT NOT NULL,
req_accepted_by INT NOT NULL,
date_sent date NOT NULL,
date_accepted date NOT NULL,
FOREIGN KEY (req_accepted_by) REFERENCES Users(user_id),
FOREIGN KEY (req_sent_from) REFERENCES Users(user_id)
);

SELECT * FROM Friends;
DROP TABLE Friends;

CREATE TABLE Likes(
user_id INT NOT NULL AUTO_INCREMENT,
post_id int NOT NULL,
date_created DATE NOT NULL,
PRIMARY KEY(user_id,post_id),
FOREIGN KEY (post_id) REFERENCES Posts(post_id),
FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

SELECT * FROM Likes;
DROP TABLE Likes;

-- QUERIES

-- Users using gmail.com
SELECT username FROM Users WHERE email LIKE '%gmail.com';
-- Users posting after a particular date
SELECT username FROM users where user_id IN(SELECT user_id FROM posts WHERE date_posted>'2020-01-01');
-- Inactive users
SELECT username FROM users where user_id NOT IN(SELECT user_id FROM posts);
-- Users liking most posts
SELECT username FROM users where user_id IN(SELECT DISTINCT user_id FROM likes GROUP BY user_id ORDER BY COUNT(user_id) DESC);
-- Users with most likes
SELECT username FROM users where user_id IN(SELECT user_id FROM Posts where post_id IN( SELECT post_id FROM Likes GROUP BY post_id ORDER BY COUNT(post_id) DESC));
-- User who never comments
SELECT username FROM users where user_id NOT in(SELECT user_id FROM comments);
-- User not followed by anyone
SELECT username from users where user_id not in (select request_acceptor_id from Followers);
-- User not following anyone
SELECT username from users where user_id not in (select request_sender_id from Followers);
-- User who makes inappropriate captions in posts 
SELECT username from users where user_id in (select user_id from posts where caption like '%***%');
-- Inactive Users
SELECT username from users where active_status='no';
-- Messages received by a particular user
SELECT content from messages where user_id_to=3;
-- Male users
SELECT username from users where gender='M';