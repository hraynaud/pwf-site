class AttendanceSheetPdf <Prawn::Document
  STUDENTS_PER_PAGE = 50.0
  STAFF_PER_PAGE = 25.0

  CHECK_BOX_TEXT = " " * 6
  STAFF_TIME_IN = " " * 60

  def initialize(sheet)
    super()
    @enrollment = sheet.student_attendances
    @date = sheet.formatted_session_date
    @student_data =  @enrollment.ordered.map{|enrolled|[name_with_attendence(enrolled), CHECK_BOX_TEXT]}
    @staff_data =  [["Instructor Name", "Check-in Time"]]
    sheet.staff_attendances.ordered.each{|staff|@staff_data << [staff_name_with_attendence(staff) , STAFF_TIME_IN]}
    @pages = ( @enrollment.size/STUDENTS_PER_PAGE).ceil

    repeat(:all) do
      pad(10){text "PWF Sign In #{@date} ", :size=>15, :align =>:center}
    end

    draw_student_sheets
    draw_staff_sheet
  end


  def missing_rc
    @arr ||= ENV["BAD_RC"].split(",").map(&:to_i)
  end

  def missing_indicator id
    id.in?(missing_rc) ? "<b>*</b>" : ""
  end

  def draw_student_sheets
    0.upto(@pages - 1) do |page|
      batch = assemble_batch_for page
      print_batch batch
      start_new_page if page <= @pages - 1
    end
  end

  def draw_staff_sheet
    move_down 50
    bounding_box([0, cursor],  :width => bounds.width) do
      table @staff_data, header: true
    end
  end

  def draw_student_sheets
    0.upto(@pages - 1) do |page|
      batch = assemble_batch_for page
      print_batch batch
      start_new_page if page <= @pages - 1
    end
  end

  def print_batch batch
    print_page_header batch_description(batch)
    column_box([0, cursor], :columns => 2, :width => bounds.width) do
      table batch, :cell_style => { :inline_format => true }
    end
  end

  def assemble_batch_for page
    offset = page * STUDENTS_PER_PAGE
    @student_data.slice(offset, STUDENTS_PER_PAGE)
  end

  def name_with_attendence student
    "#{student.first_name.titleize} #{student.last_name.titleize}:  #{current_attendances student}"
  end

  def staff_name_with_attendence staff
    "#{staff.name}:  #{current_attendances staff}"
  end

  def current_attendances person
    person.current_present_attendances.count
  end

  def batch_description batch
    with_starting_and_ending_student_listed_on_page batch
  end

  def with_starting_and_ending_student_listed_on_page batch
    {starting: batch.first.first, ending: batch.last.first}
  end

  def print_page_header header_name
    move_down 50
    bounding_box([0, cursor],  :width => bounds.width) do
      pad(10){text "#{header_name[:starting]} - #{header_name[:ending]}",  :align => :center, :style => :bold, :inline_format => true}
    end
  end


end

