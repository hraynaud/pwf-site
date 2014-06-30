class AddAcademicYearToReportCards < ActiveRecord::Migration
  def change
    add_column :report_cards, :academic_year, :string
  end
end
