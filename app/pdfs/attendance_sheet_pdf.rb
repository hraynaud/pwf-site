class AttendanceSheetPdf <Prawn::Document
  NAMES_PER_PAGE = 50.0

  CHECK_BOX_TEXT = "      "

  def initialize(sheet, date)
    super()
    @date = date
    @enrollment = sheet
    @num_students = sheet.size
    @student_data = sheet.map{|enrolled|[name_with_attendence(enrolled), "     "]}
    @pages = (@num_students/NAMES_PER_PAGE).ceil
    draw_sheets

  end

  def missing_rc
    @arr ||= ENV["BAD_RC"].split(",").map(&:to_i)
  end

  def missing_indicator id
    id.in?(missing_rc) ? "<b>*</b>" : ""
  end

  def draw_sheets
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
    offset = page * NAMES_PER_PAGE
    @student_data.slice(offset, NAMES_PER_PAGE)
  end

  def name_with_attendence enrollee
    "#{enrollee.first_name.titleize} #{enrollee.last_name.titleize}:  #{current_attendances enrollee}"
  end

  def current_attendances enrollee
    enrollee.current_attendances.count
  end

  def batch_description batch
    with_starting_and_ending_student_listed_on_page batch
  end

  def with_starting_and_ending_student_listed_on_page batch
    {starting: batch.first.first, ending: batch.last.first}
  end

  def print_page_header header_name
    pad(10) {text "PWF Sign In #{@date} w/Attendance", :size=>15, :align =>:center}
    pad(5){text "#{header_name[:starting]} - #{header_name[:ending]}",  :align => :center, :style => :bold, :inline_format => true}
  end


end

