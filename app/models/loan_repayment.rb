class LoanRepayment < ApplicationRecord
  belongs_to :user
  belongs_to :loan
  has_one :member, through: :loan

  validates :repayment_month, uniqueness: { scope: :loan_id, message: "already exists for this loan in this month" }
end
