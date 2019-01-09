ActiveAdmin.register Grade do
  belongs_to :report_card

  permit_params :subject_id,:value, :subject_name

  controller do
    def create

      report_card = ReportCard.find(params[:report_card_id])
      grade = report_card.grades.create(subject_id: params[:id], value:params[:value], new_subject_name: params[:subject_name] )

      if grade.valid?
        render json: {grade: grade.as_json(only: [:id, :value, ], methods: [:subject_name,:score])}.merge({average: report_card.average})
      else
        response.headers["X-Message"] = grade.errors.full_messages
        head :unprocessable_entity
      end
    end

    def destroy
      destroy! do
        report_card = resource.report_card
        render json: {average: report_card.average} and return
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
      @report_card.grades.as_json(only: [ :value, :subject_id ], methods: [:subject_name, :score])
    end
  end
end
