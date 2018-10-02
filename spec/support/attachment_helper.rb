module AttachmentHelper
  extend self
  extend ActionDispatch::TestProcess

   def pdf name
     upload(name, 'application/pdf') 
   end

  private

  def upload(name, type)
    file_path = Rails.root.join('spec', 'support', 'assets', name)
    fixture_file_upload(file_path, type)
  end
end
