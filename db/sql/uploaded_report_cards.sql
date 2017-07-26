SELECT 
s.id "student_id",
c.id "Report Card ID",
s.first_name "Student First Name", 
s.last_name "Student Last Name", 
u.first_name "Parent First Name",
u.last_name "Parent Last Name",
u.email  "Parent Email",
r.id "Registration ID",
c.season_id "Season ID",
c.created_at

FROM student_registrations r 
JOIN students s ON r.student_id = s.id
JOIN report_cards c ON r.id = c.student_registration_id
JOIN parents p ON s.parent_id = p.id
JOIN users u ON u.profileable_id = p.id
JOIN seasons t ON r.season_id = t.id and t.current is true

WHERE 
c.transcript IS NOT NULL 

AND r.status_cd in (1,2) 
/*AND r.season_id=15*/
AND u.profileable_type = 'Parent'
AND c.created_at > '2017-06-01'
ORDER BY c.created_at DESC