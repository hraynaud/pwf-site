ActiveAdmin.register_page "Student Demographics" do
  menu parent: "Reporting"
  controller do 

    def grp
      params[:grp] || "all"
    end

    def index
      @dashboard = StudentsDemographicsDashboard.new(grp)
    end

  end

  content do
    render  "student_stats"
  end

  sidebar :filter do
    @grp = controller.grp
    form action: admin_student_demographics_path do

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

      div do
        button "Filter"
      end
    end
  end
end
