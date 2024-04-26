-- A script that creates a stored procedure ComputeAverageScoreForUser that
-- computes and stores the average score for a student.
DROP PROCEDURE IF EXISTS ComputeAverageScoreForUser;
DELIMITER $$

CREATE PROCEDURE ComputeAverageScoreForUser (user_id INT)
BEGIN
    DECLARE total_score FLOAT;
    DECLARE projects_count INT;

    -- Compute total score and number of projects
    SELECT SUM(score), COUNT(*)
    INTO total_score, projects_count
    FROM corrections
    WHERE user_id = user_id;

    -- Update average score for the user
    UPDATE users
    SET average_score = IFNULL(total_score / NULLIF(projects_count, 0), 0)
    WHERE id = user_id;
END $$

DELIMITER ;
