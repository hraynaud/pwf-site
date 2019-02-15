ActiveAdmin.register Payment do
  menu parent: "Administration"

  scope "Fencing", :fencings, default: true
  scope "AEP", :aeps

  filter :season, collection: Season.by_season
  filter :parent, :collection => Parent.ordered_by_name


  controller do
    before_action only: :index do
      # when arriving through top navigation
      if params.keys == ["controller", "action"]
        extra_params = {"q" => {"season_id_eq" => Season.current.id}}
        params.merge! extra_params
        request.query_parameters.merge! extra_params
      end
    end 
    def new
      @parent = Parent.find(params[:parent_id])
      @payment = @parent.payments.build
    end

    def create
      @payment = Payment.new(params[:payment].merge(:completed => true))
      if @payment.save
        redirect_to admin_payment_path(@payment)
      else
        render :new
      end
    end
  end

  index do
    column :parent
    column :season do|payment|
     payment.season_description
    end
    column :amount
    column :created_at
    actions
  end

  show :title => proc {"Payment Tracking Id: #{@payment.id}"} do |payment|
    attributes_table do
      row :parent
      row :season
      row :amount
      row :stripe_charge_id
      row "Method" do

      end
      row :id
      row :created_at
    end

    panel "Paid Registrations" do
      table_for(payment.attached_registrations) do
        column("Student") {|r| link_to r.student_name, admin_student_registration_path(r) }
        column(:description)
        column(:fee)
      end
    end
  end



  sidebar "Affected Student Registrations", :only => [:new,:create] do
    table_for(payment.student_registrations.current.pending) do |t|
      t.column("Student") {|student_registration| link_to student_registration.student_name, admin_student_registration_path(student_registration)  }
    end
  end

  form do |f|
    num_regs = payment.parent.student_registrations.current.count
    amount = num_regs * Season.current.fencing_fee
    f.inputs  "Payment by: #{payment.parent.name} - For: #{pluralize(num_regs, 'Registration')} - Total Amount: $#{amount}  " do
     f.input :payment_medium, :collection => Payment.by_check_or_cash, :as => :radio
      f.input :check_no
      f.input :parent_id,  :as => :hidden, :input_html =>{:value => payment.parent.id}
      f.input :amount, :as => :hidden, :input_html =>{:value => amount}
    end
    f.actions "commit"
  end


end
