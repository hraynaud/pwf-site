class TextInput < SimpleForm::Inputs::TextInput
  def input_html_options
    {:cols =>75, :rows=>10}
  end
end
