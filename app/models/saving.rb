class Saving < ApplicationRecord
  belongs_to :member
  belongs_to :user

  # optional: if you want predefined categories
  SAVING_CATEGORIES = ["random", "ordinary" ]

  def self.categories
    SAVING_CATEGORIES
  end
end
