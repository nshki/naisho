class FaqComponent < ApplicationComponent
  # Constructor.
  #
  # @param questions [Array<{question: String, answer: String}>]
  # @param heading [String, nil] Optional heading
  # @return [FaqComponent]
  def initialize(questions:, heading: nil)
    @questions = questions
    @heading = heading
  end
end
