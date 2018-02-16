class AttendanceSheetPdf <Prawn::Document
  def initialize(date, registrations)
    super()
    @date = date
    @registrations = registrations
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

    @students = @registrations.map{|r| [r.student.first_name.titleize, r.student.last_name.titleize, r.attendances.present.count, missing_indicator(r.student.id)]}
    @sorted =  @students.sort_by{|n|[n[1],n[0]]}
    @names = @sorted.map{|n| "#{n[0]} #{n[1]}: #{n[2]} #{n[3]}"}
    data = @names.map{|n|[n, " "*8]}
    count = @registrations.count
    per_page = 54.0
    slices = (count/per_page).ceil
    0.upto(slices-1) do|slice|
      idx = slice * per_page
      chunk = data.slice(idx,per_page)
      header chunk.first.first, chunk.last.first
      column_box([0, cursor], :columns => 2, :width => bounds.width) do
        table chunk
      end
      start_new_page
    end
  end

  def header first, last 
    pad(10) {text "PWF Sign In #{@date} w/Attendance", :size=>15, :align =>:center}
    pad(5){text "#{first} - #{last}",  :align => :center, :style => :bold}
  end


end

