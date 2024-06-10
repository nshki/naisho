# Renders a button-like element, depending on whether an `href` is provided or not.
class ButtonComponent < ApplicationComponent
  # Constructor.
  #
  # @param text [String] The button's text
  # @param href [String, nil] The button's URL, if any
  # @param variant [Symbol, nil] [:primary, :secondary]
  # @param html [Hash] Additional HTML attributes
  # @return [ButtonComponent]
  def initialize(text:, href: nil, variant: :primary, **html)
    @text = text
    @href = href
    @variant = variant
    @html = html
  end

  # Outputs a modifier class based on the variant.
  #
  # @return [String]
  def modifier_class
    "button--#{@variant}"
  end
end
