module GradesHelper
  def link_to_add_fields(name, f)
    grade =Grade.new 
    id = '__DUMMY_ID__'
    fields = f.fields_for(:grades, grade, child_index: id) do |builder|
      render(partial:  "grade_fields", locals: {f: builder})
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end


end
