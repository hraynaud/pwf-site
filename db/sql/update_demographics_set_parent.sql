
UPDATE demographics SET parent_id_bkp = parent_id;

UPDATE demographics
SET parent_id = u.id
FROM users u
WHERE profileable_type='Parent' AND
u.profileable_id = demographics.parent_id;
