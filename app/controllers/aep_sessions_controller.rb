class AepSessionsController < ApplicationController

private
def aep_session_params  
  params.require(:aep_session).permit(:notes,
:session_date, :season_id,:session_date, :notes, :aep_attendances_attributes,
:season_id )
end


end
