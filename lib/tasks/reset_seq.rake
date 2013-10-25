require 'active_record'
namespace :db do
	namespace :util do
		task :reset_sequences => [:environment] do
			ActiveRecord::Base.connection.tables.each do |t|
				ActiveRecord::Base.connection.reset_pk_sequence!(t)
			end;nil
		end
	end
end