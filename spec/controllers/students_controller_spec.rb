RSpec.describe StudentsController do
  before do
    @parent1 = FactoryBot.create(:parent, :with_student)
    @student1 = @parent1.students.first
    @parent2 = FactoryBot.create(:parent, :with_student)
    @student2 = @parent2.students.first
    sign_in(@parent1)
  end

 describe "get edit" do
   it "prevents parents from seeing students who are not their own" do
     expect( get :edit,  params:{id: @student2.id} ).to redirect_to(dashboard_path) 
   end

 end


end
