select first_name, last_name, periods.name
from report_cards as cards join marking_periods as periods
on cards.marking_period_id = periods.id join student_registrations as reg
on cards.student_registration_id = reg.id join students
on reg.student_id = students.id

