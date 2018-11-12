ActiveAdmin.register Grade do
  menu :parent => "Report Cards"

  includes :report_card

  config.clear_sidebar_sections!

   index :title => "Grades" do
     render "report_card_app"
  end

end
