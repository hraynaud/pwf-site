ActiveAdmin.register Payment do

  config.clear_action_items!

  action_item do
    # link_to "Delete", admin_destroy_payment_path(payment)
  end

  controller do
    def scoped_collection
      end_of_association_chain.includes(:parent)
    end
  end

  scope :all
  scope :current

  filter :parent, :collection => Parent.order("last_name asc, first_name asc").where("first_name is not null")

  index do
    column :parent, :sortable =>'parents.first_name, parents.last_name   ' , :collection => proc {Parent.all.map {|p| "#{p.first_name} #{p.last_name}"}}

    column :season
    column :amount
    column :created_at
    default_actions
  end

  show :title => proc {"Payment for: #{@payment.payments_for}"} do |payment|
    attributes_table do
      row :parent
      row :season
      row :amount
      row "Method" do

      end
      row :id
      row :created_at
    end

    panel "Paid Registrations" do
      table_for(payment.attached_registrations) do |t|
        t.column("Student") {|student_registration| link_to student_registration.student_name, admin_student_registration_path(student_registration)  }
      end
    end
  end

  controller do
    # This code is evaluated within the controller class

    def new
      @parent = Parent.find(params[:parent_id])
      @payment = @parent.payments.build
    end

    def create
      @payment = Payment.new(params[:payment])
      if @payment.save
        redirect_to admin_payment_path(@payment)
      else
        render :new
      end
    end

  end
  # collection_action :new, :method => :get do
  # end



  sidebar "Affected Student Registrations", :only => [:new,:create] do
    table_for(payment.parent.current_unpaid_pending_registrations) do |t|
      t.column("Student") {|student_registration| link_to student_registration.student_name, admin_student_registration_path(student_registration)  }
    end
  end

  form do |f|
    num_regs = payment.parent.current_unpaid_pending_registrations.count
    amount = num_regs * Season.current.fencing_fee
    f.inputs  "Payment by: #{payment.parent.name} - For: #{pluralize(num_regs, 'Registration')} - Total Amount: $#{amount}  " do
      f.input :method, :collection => Payment.by_check_or_cash, :as => :radio
      f.input :check_no
      f.input :parent_id,  :as => :hidden, :input_html =>{:value => payment.parent.id}
      f.input :amount, :as => :hidden, :input_html =>{:value => amount}
    end
    f.buttons "commit"
  end


end
