ActiveAdmin.register Grade do
  belongs_to :report_card


  controller do
    def create
      @report_card = ReportCard.find(params[:report_card_id])
      head :ok
    end

    def index
      @report_card = ReportCard.find(params[:report_card_id])
      respond_to do |format|
        format.html
        format.json { render json: @report_card.grades.as_json(only: [ :value, :subject_id, ], methods: [:subject_name, :score])}
      end
    end
  end
end
