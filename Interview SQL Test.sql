WITH cte_points 
	AS (
    SELECT option_a AS course_name, 
           CASE 
             WHEN votes_a - votes_b > 0.1 * (votes_a + votes_b) THEN 1.0 
             WHEN abs(votes_b - votes_a) <= 0.1 * (votes_a + votes_b) THEN 0.5 
             ELSE 0.0 
           END AS points
    FROM survey
    
    UNION ALL
    
    SELECT option_b as course_name, 
           CASE 
             WHEN votes_b - votes_a > 0.1 * (votes_a + votes_b) THEN 1.0 
             WHEN abs(votes_a - votes_b) <= 0.1 * (votes_a + votes_b) THEN 0.5 
             ELSE 0.0 
           END AS points
    FROM survey
  ),
  points AS (
    SELECT 
		course_name, 
        SUM(points) AS total_points
    FROM cte_points
    GROUP BY course_name
  )
  
SELECT c.course_name, 
    COALESCE(total_points, 0) AS popularity
FROM course c
LEFT JOIN points p
	On c.course_name = p.course_name 
GROUP BY c.course_name
ORDER BY popularity DESC;