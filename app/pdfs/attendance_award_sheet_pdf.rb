class AttendanceAwardSheetPdf <Prawn::Document
  STUDENTS_PER_PAGE = 50.0
  STAFF_PER_PAGE = 25.0

  def initialize()
    super()
    @enrollment = StudentRegistration.current.confirmed
    @staff_data =  [["Instructor Name", "Size"]]

    @hoodies = AttendanceAwards.hoodies(@enrollment, {})
    @hoodie_data =  @hoodies.map{|enrolled|[name_with_attendence(enrolled), enrolled.size.to_s]}

    @t_shirts = AttendanceAwards.t_shirts(@enrollment, {})
    @t_shirts_data =  @t_shirts.map{|enrolled|[name_with_attendence(enrolled), enrolled.size.to_s]}

    #@no_awards = AttendanceAwards.no_awards(@enrollment, {})

    #@no_awards_data =  @no_awards.map{|enrolled|[name_with_attendence(enrolled), enrolled.size]}
    repeat(:all) do
      pad(10){text "PWF End of Season Awards List", :size=>15, :align =>:center}
    end

    #, @no_awards_data
    [@hoodie_data, @t_shirts_data].each do |group|
      draw_student_sheets group
    end

    #draw_staff_sheet
  end


  def draw_student_sheets group
    pages = ( @enrollment.size/STUDENTS_PER_PAGE).ceil
    0.upto(pages - 1) do |page|
      batch = assemble_batch_for group, page
      print_batch batch
      start_new_page if page <= pages - 1
    end
  end


  def draw_staff_sheet
    move_down 50
    bounding_box([0, cursor],  :width => bounds.width) do
      table @staff_data, header: true
    end
  end

  def print_batch batch
    #print_page_header batch_description(batch)
    column_box([0, cursor], :columns => 2, :width => bounds.width) do
      table batch, :cell_style => { :inline_format => true } if batch
    end
  end

  def assemble_batch_for group,  page
    offset = page * STUDENTS_PER_PAGE
    group.slice(offset, STUDENTS_PER_PAGE)
  end

  def name_with_attendence student
    "#{student.student_first_name.titleize} #{student.student_last_name.titleize}:  #{current_attendances student}"
  end

  def staff_name_with_attendence staff
    "#{staff.name}:  #{current_attendances staff}"
  end

  def current_attendances person
    person.student.current_present_attendances.count
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

