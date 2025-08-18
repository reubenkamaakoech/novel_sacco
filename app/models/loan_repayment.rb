class LoanRepayment < ApplicationRecord
  belongs_to :user
  belongs_to :loan
  has_one :member, through: :loan
end
