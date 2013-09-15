module ApplicationHelper
  def us_states
    [
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Puerto Rico', 'PR'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']
    ]
  end

  def month_options
    (1..12).map {|m| [Date::MONTHNAMES[m], m]}
  end

  def format_date(d)
    d.strftime("%B %d, %Y")
  end

  def format_time(t)
    t.strftime("%I:%M %p")
  end


  def format_time_1(t)
    t.strftime("%I:%M")
  end

  def open_enrollment
    current_season.open_enrollment_enabled
  end

  def can_register? student
    student.registered_last_year? || open_enrollment
  end

  def student_registration_helper student
    if (can_register? student) 
      link_to " click here to register #{student.pronoun}", new_student_registration_path(:student_id=> student.id), :id => "register_student_#{student.id}"
    else
      " and was not registered last year. Please wait for open enrollment on #{current_season.open_enrollment_date}"
    end
  end


  def yesno(x)
    x ? "Yes" : "No"
  end

  def student_aep_link(student)
    if student.currently_registered?
      if student.currently_in_aep?
        concat(link_to "Yes, view profile", aep_registration_path(student.current_aep_registration), :id=>"aep_profile" )
      else
        concat(link_to 'No, register here', new_aep_registration_path(:student_id =>student.id) , :class=>"btn btn-primary", :id=>"new_aep_registration")
      end
    end
  end

  def report_collection_links(rep)
    action = rep.confirmed? ? "Show" : "Edit"
    concat link_to(action, resource_action_path(rep, action), :class => 'btn btn-mini')
    concat " "
    concat link_to("Delete", resource_action_path(rep, ""),
                   :method => :delete,
                   :data => { :confirm =>  'Are you sure?'},
                   :class => 'btn btn-mini btn-danger' ) unless rep.confirmed?
  end

  def resource_action_path(obj,action)
    action =="Edit" ? edit_resource_path(obj) : resource_path(obj)
  end

  def new_resource_link(params={})
    link_to "New", new_resource_path(params), :class => 'btn btn-primary'
  end

  def submission_date rep
  format_date rep.updated_at if rep.confirmed?
  end

  def is_mgr?
    current_user.is_mgr?
  end

  def is_parent?
    current_user.is_parent?
  end
end
