class PromptsController < ApplicationController
  def create
    engine = Boxcars::Openai.new(max_tokens: 256)
    calc = Boxcars::Calculator.new(engine: engine)
    result = calc.run(params[:input_field])
    puts result.to_s
  end

  def show
  end
end
