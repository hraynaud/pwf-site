ActiveAdmin.register ReportCard do
  scope :current
  scope :all
  filter :student, :collection => Student.order("last_name asc, first_name asc")
  filter :season
  filter :academic_year_cont

  index do
    column :student
    column "Uploaded At" do |c|
      c.created_at
    end
    actions defaults: true do |c|
      link_to "Download", rails_blob_path(c.transcript, disposition: "attachment"), class: 'member_link' if c.transcript.attached?
    end
  end


end
