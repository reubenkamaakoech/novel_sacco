class LoanRepayment < ApplicationRecord
  belongs_to :user
  belongs_to :loan
  has_one :member, through: :loan

  validates :repayment_month, uniqueness: { scope: :loan_id, message: "already exists for this loan in this month" }
  
  validate :cannot_exceed_loan_balance
   
  after_commit :close_loan_if_fully_paid

  before_create :store_balance

  def store_balance
    self.balance_at_time = loan.balance 
    self.balance_after  = loan.balance - amount
  end

  private
  
  def close_loan_if_fully_paid
  return unless loan

  loan.reload

  total_paid = LoanRepayment.where(loan_id: loan.id).sum(:amount)

  if total_paid >= loan.amount
    loan.update_column(:status, false)  # 🔥 bypass validations
  end
end

  def cannot_exceed_loan_balance
  return if amount.blank? || loan.blank?

    # total already repaid before this repayment
     total_repaid = loan.loan_repayments.where.not(id: id).sum(:amount)
    
    # If this repayment pushes total above the loan amount, block it
    if (total_repaid + amount) > loan.amount
    errors.add(:amount, "cannot be more than remaining loan balance (#{loan.balance})")
  end
end
end
