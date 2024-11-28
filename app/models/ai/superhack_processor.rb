module Ai
  class SuperhackProcessor
    def initialize(superhack)
      @superhack = superhack
      @model = Ai::LlmHandler.new('gemini-1.5-flash-8b')
    end
  end
end
