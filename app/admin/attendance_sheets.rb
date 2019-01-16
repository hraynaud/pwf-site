ActiveAdmin.register AttendanceSheet do
  includes :season
  permit_params :session_date,:season_id
  menu parent: "Students", label: "Attendance"
  scope "Current Season", default: true do
    AttendanceSheet.current
  end

  scope :all

  filter :session_date
  filter :season

  controller do

    def create
      sheet = AttendanceSheet.new(permitted_params[:attendance_sheet])
      sheet.season = Season.current
      sheet.save
      sheet.generate_attendances
      redirect_to admin_attendance_sheet_path(sheet)
    end

    def show
      @attendance_sheet = AttendanceSheet.find(params[:id])
      respond_to do |format|
        format.html
        format.json { render json: @attendance_sheet}
        format.pdf do
          pdf = AttendanceSheetPdf.new(@attendance_sheet.with_students.ordered, @attendance_sheet.formatted_session_date)
          disp = params[:disposition].present? ? params[:disposition] : "attachment"
          send_data pdf.render , filename: "attendance#{@attendance_sheet.session_date}.pdf", type: "application/pdf", disposition: disp
        end
      end
    end
  end

  form do |f|
    panel "New Attendance Sheet" do
      f. inputs  do
        f.input :session_date , as: :date_picker
        f.actions
      end
    end
  end

  index download_links: -> { params[:action] == 'show' ? [:pdf, :json] : [:xml, :json] }  do
    column :id
    column :session_date
    column :season do|sheet|
      sheet.season.description
    end
    actions defaults: true do |sheet|
      item 'PDF', admin_attendance_sheet_path(sheet, format: :pdf), class: 'member_link'
    end
  end

  show :title => proc {"Attendance For: #{resource.session_date}"} do
    div class: "attendance-sheet", id: "vue-app-container",  "data-load-path": admin_attendance_sheet_path(resource),  
      "data-missing-img-path": asset_path("user-place-holder-128x128.png") do
      div id: "attendance-app"
    end
  end

end
