ActiveAdmin.register ReportCard, max_width: "800px" do
  scope :current
  scope :all
  #scope :with_grades
  scope :with_transcript

  filter :student, :collection => Student.order("last_name asc, first_name asc")
  filter :season
  filter :academic_year_cont
  filter :transcript

  index do
    column :student
    column :term
    column :marking_period_name
    column "Transcipt Uploaded?" do |report_card|
      report_card.transcript.attached?
    end

    column "Uploaded At" do |c|
      c.created_at if c.transcript.attached?
    end

    column "Grades Entered" do |report_card|
      report_card.transcript.attached?
    end

    actions defaults: true do |c|
      link_to "Download", rails_blob_path(c.transcript, disposition: "attachment"), class: 'member_link' if c.transcript.attached?
    end
  end

  show do
    columns do

      column max_width: "25%" do
        attributes_table do
          row "Name" do 
            report_card.student_name
          end

          row "School year" do
            report_card.term
          end

          row :format
          row "Period" do
            :marking_period_name
          end

          row "Graded" do
            report_card.has_grades?
          end

          row "Transcript?" do
            report_card.transcript.attached?
          end
          row :created_at
        end
      end
      column max_width: "25%" do
        #sidebar "Grades", only: [:show, :edit] do
        table_for report_card.grades do
          column :subject
          column "Grade", :value
          column :grade
          column "Scaled Grade", :hundred_point
        end
        #end
      end 

      column min_width: "45%" do
          render "report_cards/transcript_viewer", {report_card: report_card}
      end
    end

  end

end
