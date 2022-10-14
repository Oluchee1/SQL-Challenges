WITH points
	AS (
SELECT a.course_name, points_a + points_b AS total_points
FROM
(SELECT option_a AS course_name,
CASE
WHEN votes_a - votes_b > 0.1 * (votes_a + votes_b) THEN 1.0
WHEN abs(votes_b - votes_a) <= 0.1 * (votes_a + votes_b) THEN 0.5
ELSE 0.0
END AS points_a
FROM survey)a 
LEFT JOIN 
(SELECT option_b as course_name,
CASE
WHEN votes_b - votes_a > 0.1 * (votes_a + votes_b) THEN 1.0
WHEN abs(votes_a - votes_b) <= 0.1 * (votes_a + votes_b) THEN 0.5
ELSE 0.0
END AS points_b
FROM survey)b
ON a.course_name = b.course_name
)
SELECT c.course_name,
SUM(COALESCE(total_points, 0)) AS popularity
FROM course c
LEFT JOIN points p
	On c.course_name = p.course_name
GROUP BY c.course_name
ORDER BY popularity DESC;

