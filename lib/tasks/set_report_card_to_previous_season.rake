require 'active_record'
namespace :db do
  namespace :reg_data do

    desc "Reassign report cards wrongly in this season to  previous season" 
    task :reassign_repot_cards => [:environment] do

      ReportCard.in_wrong_season.each do |card|
        card.reassign_to_last_season
      end
    end
  end
end



