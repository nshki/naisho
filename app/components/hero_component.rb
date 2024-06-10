# Renders a large section that gives the TL;DR of the page.
class HeroComponent < ApplicationComponent
  renders_one :actions

  # Constructor.
  #
  # @param heading [String]
  # @param description [String]
  # @return [HeroComponent]
  def initialize(heading:, description:)
    @heading = heading
    @description = description
  end

  # Calculates a modifier class, if any.
  #
  # @return [String]
  def modifier_class
    actions.present? ? "hero--tall" : ""
  end
end
