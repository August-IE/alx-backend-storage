-- A script that creates a stored procedure ComputeAverageWeightedScoreForUsers that
-- computes and store the average weighted score for all students.
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers;
DELIMITER $$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers ()
BEGIN
    -- Declare variables
    DECLARE total_weighted_score FLOAT;
    DECLARE total_weight FLOAT;

    -- Add temporary columns to store total weighted score and total weight
    ALTER TABLE users ADD COLUMN total_weighted_score FLOAT;
    ALTER TABLE users ADD COLUMN total_weight FLOAT;

    -- Compute total weighted score and total weight for each user
    UPDATE users
    SET total_weighted_score = (
        SELECT IFNULL(SUM(corrections.score * projects.weight), 0)
        FROM corrections
        INNER JOIN projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = users.id
    ),
    total_weight = (
        SELECT IFNULL(SUM(projects.weight), 0)
        FROM corrections
        INNER JOIN projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = users.id
    );

    -- Update average score for each user
    UPDATE users
    SET average_score = IF(total_weight = 0, 0, total_weighted_score / total_weight);

    -- Drop temporary columns
    ALTER TABLE users DROP COLUMN total_weighted_score;
    ALTER TABLE users DROP COLUMN total_weight;
END $$

DELIMITER ;
