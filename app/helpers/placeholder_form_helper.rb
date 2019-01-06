require "placeholder_form_builder"
module PlaceholderFormHelper
  def placeholder_form_for(object, *args, &block)
    options = args.extract_options!
    simple_form_for(object, *(args << options.merge(:builder => PlaceholderFormBuilder)), &block)
  end

  def placeholder_fields_for(*args, &block)
    options = args.extract_options!
    simple_fields_for(*(args << options.merge(:builder => PlaceholderFormBuilder)), &block)
  end
end
