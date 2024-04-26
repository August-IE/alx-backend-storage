-- A script that creates a stored procedure AddBonus that adds a new
-- correction for a student.
DROP PROCEDURE IF EXISTS AddBonus;
DELIMITER $$

CREATE PROCEDURE AddBonus (user_id INT, project_name VARCHAR(255), score FLOAT)
BEGIN
    DECLARE project_id INT;

    -- Check if the project exists, if not, create it
    IF NOT EXISTS (SELECT id FROM projects WHERE name = project_name) THEN
        INSERT INTO projects (name) VALUES (project_name);
    END IF;

    -- Get the project ID
    SELECT id INTO project_id FROM projects WHERE name = project_name;

    -- Insert the correction
    INSERT INTO corrections (user_id, project_id, score) VALUES (user_id, project_id, score);
END $$

DELIMITER ;
