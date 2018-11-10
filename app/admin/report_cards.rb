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

  form title: "New Report Card" do |f|
    inputs 'Details' do
      input :student_registration, as: :select, collection: StudentRegistration.current_confirmed.map{|s|[s.student_name, s.id]}
      input :academic_year, as: :select, collection: Season.first_and_last.map(&:term) 
      input :marking_period, as: :radio, collection: MarkingPeriod.simple_periods{|m|[ m.name, m.id ]} 
      input :format_cd, as: :radio, collection: GradeConversionService.for_select, label: "Grade Type"
    end
  end

  show title: ->(report_card){"#{report_card.student_name}/#{report_card.term}/#{report_card.marking_period_name}" } do
    columns do

      column min_width: "65%" do
        panel "Transcript" do
          render "report_cards/transcript_iframe", {report_card: report_card}
        end
      end

      column max_width: "33%" do
        panel "Grades" do
          table_for report_card.grades do
            column :subject
            column "Grade", :value
            column "Grade *", :hundred_point
          end
        end
      end 
    end
  end
end
