require 'erb'
require 'ostruct'

class ErbalT < OpenStruct
  def render(template)
    ERB.new(template).result(binding)
  end
end
