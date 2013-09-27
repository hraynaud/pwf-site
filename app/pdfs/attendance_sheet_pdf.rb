class AttendanceSheetPdf <Prawn::Document
  def initialize(date, registrations)
    super()
    @date = date
    @registrations = registrations 
    p = 0;
    draw_page
  end

  def draw_page
    @names = @registrations.map{|r| [r.student.first_name.titleize,r.student.last_name.titleize ]}.sort_by(&:last).map{|n|n.join(" ")}
    data = @names.map{|n|[n, " "*10]}
    count = @registrations.count
    per_page = 54.0
    slices = (count/per_page).ceil
    0.upto(slices) do|slice|
      idx = slice * per_page
      header
      column_box([0, cursor], :columns => 2, :width => bounds.width) do
        table data.slice(idx,per_page)
      end
      start_new_page
    end
  end

  def header
    pad(10) {text "PWF Sign In #{@date}", :size=>15, :align =>:center}
    move_down 15 
    first=(page_number-1)*54
    last=(page_number-1)*54 + 53
    #text "#{@names[first]} - #{@names[last]}"
  end


end

