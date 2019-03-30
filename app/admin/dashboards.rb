ActiveAdmin.register_page "Dashboard" do
  menu priority: 0
  content do
    columns do
      column do
        div do
          h2 "Current Season Stats", class: "text-center"
        end
        render  "season_summary" unless Season.current.nil?
      end
    end
  end
end
