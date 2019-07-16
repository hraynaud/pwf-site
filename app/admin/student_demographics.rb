ActiveAdmin.register_page "Student Demographics" do
  menu parent: "Demographics", label: "Student Summary"
  controller do 
    before_action do
      @season = params[:season_id].present? ? Season.find(params[:season_id]) : Season.current
      @grp = params[:grp] || "all"
      @group_name = @grp=="all"  ? "All Students" : "AEP Students Only"
    end

    def grp
      params[:grp] || "all"
    end

    def index
      @dashboard = StudentsDemographicsDashboard.new(grp, params[:season_id])
    end

  end
  content do
    
    render  "student_stats"
  end

  sidebar :filter do
    @grp = controller.grp
    form action: admin_student_demographics_path do
      div class: "form-elmenent-grp "do
        label "Season" 

        select name: "season_id" do
          options_from_collection_for_select(Season.most_recent_first, 'id', 'description', params[:season_id])
        end
      end

      div do 
        div class: "form-elmenent-grp inline"do
          label "All" do
            input type: "radio", name: "grp", value: "all", checked: @grp=="all"
          end
        end

        div class: "form-elmenent-grp inline"do
          label "In AEP (Paid) " do
            input type: "radio", name: "grp", value: "aep", checked: @grp == "aep"
          end
        end
      end
      div do
        button "Filter"
      end
    end
  end
end
