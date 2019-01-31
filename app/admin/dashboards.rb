ActiveAdmin.register_page "Dashboard" do
  menu priority: 0
  content do
    render  "season_summary" unless Season.current.nil?
  end
end
