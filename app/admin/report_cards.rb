ActiveAdmin.register ReportCard do
  #scope :all
  scope :current


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
