class EmailTemplate
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  attr_accessor :subject, :message

  def persisted?
   false
  end
  
  attr_accessor :exclude_list
end
