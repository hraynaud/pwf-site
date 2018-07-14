ActiveAdmin.register ReportCard do
  #scope :all
  scope :current


  index do
    column :student
    column "Uploaded At" do |c|
      c.created_at
    end
    actions defaults: true do |c|
      link_to "Download", c.transcript_url, class: 'member_link'
    end
    #column :student
    #column :student
    #column :student
  end


end
