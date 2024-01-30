CREATE DATABASE task_manager DEFAULT CHARACTER SET = 'utf8mb4';

DROP DATABASE task_manager;

USE task_manager;

--Represent the user using the app
CREATE TABLE `users` (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
    `first_name` VARCHAR(50) NOT NULL COLLATE utf8mb4_general_ci CHECK (
        `first_name` NOT REGEXP '[0-9]'
    ), 
    `last_name` VARCHAR(50) NOT NULL COLLATE utf8mb4_general_ci CHECK (
        `last_name` NOT REGEXP '[0-9]'
    ), 
    `email` VARCHAR(128) NOT NULL, 
    `username` VARCHAR(15) NOT NULL UNIQUE, 
    `password` VARCHAR(128) NOT NULL
);

--Represent the tasks
CREATE TABLE `tasks` (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
    `creator_id` INT UNSIGNED,
    `title` VARCHAR (255) NOT NULL,
    `description` TEXT NOT NULL,
    `due_date` DATETIME NOT NULL,
    `priority` ENUM('Low', 'Medium', 'High') NOT NULL,
    `status` ENUM('Not Started', 'In Progress', 'Completed') NOT NULL,
    `created_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`creator_id`) REFERENCES `users`(`id`)
);

--Represent categories for tasks
CREATE TABLE `categories` (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
    `name` VARCHAR(30) NOT NULL
);

--Represent relationship between task and category(M-t-M rela)
CREATE TABLE `task_category` (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
    `task_id` INT UNSIGNED,
    `category_id` INT UNSIGNED,
    FOREIGN KEY (`task_id`) REFERENCES `tasks`(`id`),
    FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`)
);

--Represent roles
/*
    Assignee: The person responsible for completing the task.
    Creator: The person created the task
    Approver: The person who has the authority to approve or reject the completion of the task.
    Collaborator: A general role for someone actively participating in the task but without a specific assigned responsibility.
*/
CREATE TABLE `roles` (
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
    `task_id` INT UNSIGNED,
    `assigned_user_id` INT UNSIGNED,
    `assigned_date` DATETIME NOT NULL,
    `role` ENUM('Assignee', 'Creator', 'Approver', 'Collaborator') NOT NULL,
    FOREIGN KEY (`task_id`) REFERENCES `tasks`(`id`),
    FOREIGN KEY (`assigned_user_id`) REFERENCES `users`(`id`)
);


--Reresent the comments on tasks
CREATE TABLE `comments`(
    `id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, 
    `task_id` INT UNSIGNED,
    `user_id` INT UNSIGNED,
    `comment` TEXT NOT NULL,
    `comment_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`task_id`) REFERENCES `tasks`(`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
);

-- Create indexes to speed common searches
CREATE INDEX `name` ON `users` (`first_name`, `last_name`);
CREATE INDEX `username_users` ON `users` (`username`);
CREATE INDEX `title_tasks` ON `tasks` (`title`);
CREATE INDEX `name_categories` ON `categories` (`name`);