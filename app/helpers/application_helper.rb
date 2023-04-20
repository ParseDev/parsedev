module ApplicationHelper
    def flash_class(type)
      case type.to_sym
      when :notice
        'bg-green-500 text-white px-4 py-2 rounded'
      when :alert
        'bg-red-500 text-white px-4 py-2 rounded'
      else
        'bg-blue-500 text-white px-4 py-2 rounded'
      end
    end
  end
  