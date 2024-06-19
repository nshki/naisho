# A modal intended to display more information about something.
class InfoModalComponent < ApplicationComponent
  renders_many :sections

  # Constructor.
  #
  # @param id [String] The ID of the modal; used for `popovertarget`
  # @return [InfoModalComponent]
  def initialize(id:)
    @id = id
  end
end
