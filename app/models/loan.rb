class Loan < ApplicationRecord
  belongs_to :member
  has_many :loan_repayments, dependent: :destroy
  
  validate :single_active_loan, on: :create   # <-- this is the new validation
  # Prevent status being set to true if loan is fully repaid
  before_update :prevent_reopening_fully_paid_loan, if: :status_changed?
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :bank_charges, presence: true
  validate :member_must_be_active
  before_validation :calculate_installments

   def member_must_be_active
     if member && !member.status
      errors.add(:member_id, "is not active")
     end
   end

  validates :payment_period_months, numericality: { 
    only_integer: true, 
    greater_than: 0, 
    less_than_or_equal_to: 6 
  }

  validate :amount_cannot_exceed_available

  scope :active_with_balance, -> {
  where(status: true)
    .left_joins(:loan_repayments)
    .group(:id)
    .having("COALESCE(SUM(loan_repayments.amount), 0) < loans.amount")
}

  def member_name
    member.name   # assuming members table has a "name" column
  end

  def total_loans
     amount  
  end

  def loan_repayments_total
    loan_repayments.sum(:amount)
  end

  def balance
    amount.to_d - loan_repayments.sum(:amount).to_d
  end

  def calculate_installments
  return if amount.blank? || payment_period_months.blank?

  loan_amount = amount.to_d
  period = payment_period_months.to_i
  charges = bank_charges.to_d

  monthly = loan_amount / period

  self.repayment_amount_per_month = monthly.round(2)
  self.first_installment = (monthly + charges).round(2)
end

  def total_amount_payable
    amount + bank_charges.to_d
  end

  private
  def prevent_reopening_fully_paid_loan
    if balance <= 0 && status
      errors.add(:status, "cannot be reactivated: loan is fully repaid")
      throw(:abort) # stops the update
    end
  end
  
   # New validation: only one active loan at a time
  def single_active_loan
    return unless member

    if member.loans.where(status: true).exists?
      errors.add(:member_id, "already has an active loan")
    end
  end

  def amount_cannot_exceed_available
    return if member.nil?

    total_savings = member.savings.sum(:amount)
    locked_savings = total_savings * Member.locked_ratio
    available_for_loans = total_savings - locked_savings

    if amount.present? && amount > available_for_loans
      errors.add(:amount, "cannot be more than available amount (#{available_for_loans})")
    end
  end
end
