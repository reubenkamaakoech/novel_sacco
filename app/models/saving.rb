class Saving < ApplicationRecord
  belongs_to :member
  belongs_to :user

  SAVING_CATEGORIES = ["random", "ordinary"]

  TRANSACTION_TYPES = %w[deposit withdrawal]

  validates :transaction_type, inclusion: { in: TRANSACTION_TYPES }

  before_validation :set_default_transaction_type

  def self.categories
    SAVING_CATEGORIES
  end

  private

  def set_default_transaction_type
    self.transaction_type ||= "deposit"
  end
end
