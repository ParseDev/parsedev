module ApplicationHelper
  def flash_class(type)
    case type.to_sym
    when :notice
      "bg-green-500 text-white px-4 py-4 rounded m-2"
    when :alert
      "bg-red-500 text-white px-4 py-4 rounded m-2"
    else
      "bg-blue-500 text-white px-4 py-4 rounded m-2"
    end
  end

  def active_mobile_menu_class(link_path)
    current_page?(link_path) ? "border-indigo-500 bg-indigo-50 text-indigo-700" : "border-transparent text-gray-600 hover:border-gray-300 hover:bg-gray-50 hover:text-gray-800"
  end

  def active_menu_class(link_path)
    current_page?(link_path) ? "border-indigo-500 text-gray-900" : "border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700"
  end

  def valid_ruby_code?(string)
    begin
      RubyVM::InstructionSequence.compile(string)
      true
    rescue SyntaxError
      false
    end
  end
end
