# Renders a list of steps with a title and a description.
class StepsContentComponent < ApplicationComponent
  # Constructor.
  #
  # @param heading [String, nil] Optional heading
  # @param steps [Array<{title: String, description: String}>]
  # @return [StepsContentComponent]
  def initialize(steps:, heading: nil)
    @steps = steps
    @heading = heading
  end
end
