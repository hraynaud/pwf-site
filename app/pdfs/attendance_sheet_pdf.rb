class AttendanceSheetPdf <Prawn::Document
  NAMES_PER_PAGE = 54.0

  def initialize(attendance_sheet, date)
    super()
    @date = date
    @students = attendance_sheet
    p = 0;
    draw_page
  end

  def missing_rc
    @arr ||= ENV["BAD_RC"].split(",").map(&:to_i)
  end

 def missing_indicator id
   id.in?(missing_rc) ? "<b>*</b>" : ""
 end


  def draw_page

    data = @students.map{|n|["#{n.first_name.titleize} #{n.last_name.titleize}", " "*12]}
    count = @students.size
    slices = (count/NAMES_PER_PAGE).ceil

    0.upto(slices-1) do|slice|
      idx = slice * NAMES_PER_PAGE
      chunk = data.slice(idx, NAMES_PER_PAGE)

      print_page_header with_starting_and_ending_student_listed_on_page(chunk)

      column_box([0, cursor], :columns => 2, :width => bounds.width) do
        table chunk, :cell_style => { :inline_format => true }
      end

      start_new_page
    end
  end

  def with_starting_and_ending_student_listed_on_page chunk
    {starting: chunk.first.first, ending: chunk.last.first}
  end

  def print_page_header header_name
    pad(10) {text "PWF Sign In #{@date} w/Attendance", :size=>15, :align =>:center}
    pad(5){text "#{header_name[:starting]} - #{header_name[:ending]}",  :align => :center, :style => :bold, :inline_format => true}
  end


end

