ActiveAdmin.register_page "Missing Report Cards" do
  menu parent: "Report Cards"
  content class: "active_admin" do
    @coll = StudentRegistration.current.confirmed.without_fall_winter_report_card.page(params[:page]).per(10) 
    paginated_collection @coll, entry_name: "missing", download_links: false do
      table_for @coll, class: "index_table" do
        column :student_name do |reg|
          reg.student_name
        end

        column :parent do |reg|
          reg.parent.name
        end
        column :email do |reg|
          reg.parent.email
        end
      end
    end
  end

  page_action :csv, method: :get do
    missing_report_cards = StudentRegistration.current.confirmed.without_fall_winter_report_card
    csv = CSV.generate( encoding: 'Windows-1251' ) do |csv|
      csv << [ "Student", "Parent", "Email"]
      missing_report_cards.each do |transaction|
        csv << [ transaction.student_name, transaction.parent.name, transaction.parent.email]
      end
    end
    # send file to user
    send_data csv.encode('Windows-1251'), type: 'text/csv; charset=windows-1251; header=present', disposition: "attachment; filename=missing_report_cards_#{DateTime.now.to_s}.csv"
  end
        
  action_item :add do
    link_to "Export to CSV", admin_missing_report_cards_csv_path, method: :get, format: :csv
  end
  sidebar :marking_period do
    ul do
      li "Second List First Item"
      li "Second List Second Item"
    end
  end

end

