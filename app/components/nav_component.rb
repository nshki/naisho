# Main navigation of the site.
class NavComponent < ApplicationComponent
  # Constructor.
  #
  # @param items [Array<{text: String, url: String, external: Boolean|nil}>]
  #   List of links to render
  # @return [NavComponent]
  def initialize(items:)
    @items = items
  end
end
