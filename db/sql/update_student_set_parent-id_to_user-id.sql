UPDATE students
SET parent_id = u.id
FROM users u
WHERE type='Parent'AND
u.profileable_id = students.parent_id

