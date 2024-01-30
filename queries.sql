-- USE task_manager;
-- SET @@explain_format=TREE;
-- Find all tasks given first and last name
SELECT *
FROM `tasks`
WHERE `user_id` IN (
    SELECT `id`
    FROM `users`
    WHERE `first_name` = 'John'
    AND `last_name` = 'Doe'
);

--Find role based on username
SELECT `role` FROM `roles` 
WHERE `assigned_user_id` IN (
    SELECT `id`
    FROM `users`
    WHERE `username` = 'john_doe'
); 

--Find all the collaborators on a task
SELECT `title`, `username` FROM `tasks`
JOIN `users` ON `users`.`id` = `tasks`.`user_id`
WHERE `title` = 'Task 1';

--Find all comments on task and who wrote them
SELECT `comment`, `comment_date`, `username` FROM `comments`
JOIN `users` ON `users`.`id` = `comments`.`user_id`
WHERE `task_id` = (
    SELECT `id`
    FROM `tasks`
    WHERE `title` = 'Task 1'
);

--Find all categories of a task
SELECT `name` FROM `categories` WHERE `id` IN (
SELECT `category_id` FROM `task_category` WHERE `task_id` = (
SELECT `id` FROM `tasks` WHERE `title` = 'Task 3'));



-- Insert test users
INSERT INTO `users` (`first_name`, `last_name`, `email`, `username`, `password`)
VALUES
  ('John', 'Doe', 'john.doe@example.com', 'john_doe', 'hashed_password_1'),
  ('Jane', 'Smith', 'jane.smith@example.com', 'jane_smith', 'hashed_password_2'),
  ('Tan', 'Ngo', 'nmtan2001@example.com', 'nmtan2001', 'hashed_password_3');

-- Insert test tasks
INSERT INTO `tasks` (`user_id`, `title`, `description`, `due_date`, `priority`, `status`)
VALUES
  (1, 'Task 1', 'Description for Task 1', '2024-02-01 12:00:00', 'High', 'Not Started'),
  (1, 'Task 2', 'Description for Task 2', '2024-02-15 14:30:00', 'Medium', 'In Progress'),
  (2, 'Task 3', 'Description for Task 3', '2024-03-01 09:00:00', 'Low', 'Completed');

-- Insert test categories
INSERT INTO `categories` (`name`)
VALUES
  ('Work'),
  ('Personal'),
  ('Health');

  -- Insert test task-category relationships
INSERT INTO `task_category` (`task_id`, `category_id`)
VALUES
  (1, 1), -- Task 1 is associated with the 'Work' category
  (2, 2), -- Task 2 is associated with the 'Personal' category
  (3, 3), -- Task 3 is associated with the 'Health' category
  (3, 1); -- Task 3 is also associated with the 'Work' category

  -- Insert test collaborators
INSERT INTO `roles` (`task_id`, `assigned_user_id`, `assigned_date`, `role`)
VALUES
  (1, 2, '2024-02-02 09:00:00', 'Assignee'),  -- Task 1 is assigned to User 2
  (2, 1, '2024-02-10 14:30:00', 'Creator'),  -- Task 2 is created by User 1
  (3, 2, '2024-02-20 09:00:00', 'Collaborator'),  -- Task 3 has User 2 as a collaborator
  (3, 3, '2024-02-20 09:00:00', 'Collaborator');  -- Task 3 has User 3 as a collaborator

-- Insert test comments
INSERT INTO `comments` (`task_id`, `user_id`, `comment`)
VALUES
  (1, 1, 'This is the first comment on Task 1'),  -- User 1 comments on Task 1
  (1, 2, 'Thanks for the update on Task 1'),  -- User 2 replies to the comment on Task 1
  (2, 1, 'Task 2 is in progress'),  -- User 1 comments on Task 2
  (3, 3, 'Collaborating on Task 3');  -- User 3 comments on Task 3
