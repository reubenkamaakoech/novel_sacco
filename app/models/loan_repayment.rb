class LoanRepayment < ApplicationRecord
  belongs_to :user
  belongs_to :loan
  has_one :member, through: :loan

  validates :repayment_month, uniqueness: { scope: :loan_id, message: "already exists for this loan in this month" }
  
  validate :cannot_exceed_loan_balance
   
  private

  def cannot_exceed_loan_balance
    return if amount.blank? || loan.blank?

    # total already repaid before this repayment
    total_repaid = loan.loan_repayments.sum(:amount)
    
    # If this repayment pushes total above the loan amount, block it
    if (total_repaid + amount) > loan.amount
      errors.add(:amount, "cannot be more than remaining loan balance (#{loan.balance})")
    end
  end
end
