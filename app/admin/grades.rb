ActiveAdmin.register Grade do
  belongs_to :report_card

  permit_params :subject_id,:value

  controller do
    def create

      report_card = ReportCard.find(params[:report_card_id])
      grade = report_card.grades.create(subject_id: params[:id], value:params[:value])

      if grade.valid?
        head :ok
      else 
        response.headers["X-Message"] = grade.errors.full_messages
        head :unprocessable_entity
      end
    end

    def index
      @report_card = ReportCard.find(params[:report_card_id])
      respond_to do |format|
        format.html
        format.json { render json: report_cards_data }
      end
    end

    def report_cards_data
      @report_card.grades.as_json(only: [ :value, :subject_id, ], methods: [:subject_name, :score])
    end
  end
end
