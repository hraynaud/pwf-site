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
    (1..12).map {|m| [month_name(m), m]}
  end

  def month_name m
    Date::MONTHNAMES[m]
  end

  def format_date(d)
    d.strftime("%B %d, %Y") unless d.nil?
  end

  def format_time(t)
    t.localtime.strftime("%I:%M %p")
  end


  def format_time_1(t)
    t.localtime.strftime("%I:%M")
  end



  def student_report_card_helper student
    if student.currently_registered? 
      if student.current_registration.report_cards.count > 0
        "Yes"
      else
        link_to_if(student.enrolled_last_season,  "No. Click here to Upload report card (Required)", new_report_card_path(:student_id=> student.id)) do 
           "N/A"
        end
      end
    else
      "N/A"
    end
  end

  def student_aep_link(student)
    if student.currently_registered?
      if student.currently_in_aep?
        concat(link_to "View profile", aep_registration_path(student.current_aep_registration), :id=>"aep_profile" )
      else
        concat(student.aep_eligible? ? link_to('Register here', new_aep_registration_path(:student_id =>student.id) , :class=>"btn btn-primary", :id=>"new_aep_registration") : "Not eligible due to fencing status : #{student.registration_status}")
      end
    end
  end
  def yesno(x)
    x ? "Yes" : "No"
  end

  def humanize_enum enum
    enum.to_s.titleize
  end



  def report_collection_links(rep, class_option=nil)
    action = rep.confirmed? ? "Show" : "Edit"
    concat link_to(action, resource_action_path(rep, action), :class => "btn #{class_option}")
    concat " "
    concat link_to("Delete", resource_action_path(rep, ""),
                   :method => :delete,
                   :data => { :confirm =>  'Are you sure?'},
                   :class => "btn  btn-danger #{class_option}" ) unless rep.confirmed?
  end



  def submission_date rep
    format_date rep.updated_at if rep.confirmed?
  end

  def is_mgr?
    current_user.is_mgr?
  end

  def is_parent?
    current_user.is_parent? && current_user.type == "Parent"
  end
end
