class LoanRepayment < ApplicationRecord
  belongs_to :user
  belongs_to :loan
  has_one :member, through: :loan

  validates :repayment_month, uniqueness: { scope: :loan_id, message: "already exists for this loan in this month" },
          unless: :is_refinance_settlement?
  
  validate :one_normal_repayment_per_month
  validate :cannot_exceed_loan_balance
   
  after_commit :close_loan_if_fully_paid

  before_create :store_balance
  after_create :refund_bank_charge_to_savings

  def store_balance
    self.balance_at_time = loan.balance 
    self.balance_after  = loan.balance - amount
  end

  private
def one_normal_repayment_per_month
  return if is_refinance_settlement?

  if LoanRepayment.where(
       loan_id: loan_id,
       repayment_month: repayment_month,
       is_refinance_settlement: false
     ).where.not(id: id).exists?

    errors.add(:repayment_month, "already exists for this loan in this month")
  end
end
  
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

  if amount > loan.balance
    errors.add(:amount, "cannot exceed remaining balance (#{loan.balance})")
  end
end

def refund_bank_charge_to_savings
  return if bank_charge_paid # just added a check to avoid double refunding
  return unless loan.loan_repayments.count == 1
  return if loan.bank_charges.to_d <= 0

  Saving.create!(
    member: loan.member,
    user_id: user_id,
    amount: loan.bank_charges,
    transaction_type: "deposit",
    deposit_type: "Bank Charge Paid",
    month: repayment_date || Date.current)

    loan.update!(bank_charge_paid: true)
    update_column(:bank_charge_paid, true) # optional if you want to record it on this repayment
  end
end
