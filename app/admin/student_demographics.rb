ActiveAdmin.register_page "Student Demographics" do
  menu parent: "Reporting"
  content do
    render  "student_stats"
  end
end
