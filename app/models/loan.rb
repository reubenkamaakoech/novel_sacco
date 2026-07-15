class Loan < ApplicationRecord
  belongs_to :member
  has_many :loan_repayments, dependent: :destroy
  belongs_to :refinanced_from, class_name: "Loan", optional: true
  has_one :refinanced_to, class_name: "Loan", foreign_key: :refinanced_from_id, dependent: :destroy
  has_many :savings, dependent: :nullify
  
  validate :single_active_loan, on: :create   # <-- this is the new validation
  # Prevent status being set to true if loan is fully repaid
  before_update :prevent_reopening_fully_paid_loan, if: :status_changed?
  
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :bank_charges, presence: true
  validate :member_must_be_active
  before_validation :calculate_installments
  after_create :deduct_bank_charge_from_savings

  def refinance?
    is_refinance?
  end

  def can_refinance?
    status == true && balance.positive?
  end

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
  validate :refinance_amount_must_exceed_balance

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

  def outstanding_bank_charge
     bank_charge_paid? ? 0.to_d : bank_charges.to_d
  end

  def settlement_amount
    balance + outstanding_bank_charge
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

  private
  def refinance_amount_must_exceed_balance
    return unless is_refinance?
    return unless refinanced_from

    if amount.to_d <= refinanced_from.settlement_amount.to_d
    errors.add(:amount, "must be greater than the outstanding balance (#{refinanced_from.balance})")
    end
  end

  def prevent_reopening_fully_paid_loan
    if balance <= 0 && status
      errors.add(:status, "cannot be reactivated: loan is fully repaid")
      throw(:abort) # stops the update
    end
  end
  
   # New validation: only one active loan at a time
  def single_active_loan
    return unless member

      active_loans = member.loans.where(status: true)

    # If this is a refinance, ignore the loan being refinanced
    if refinanced_from_id.present?
      active_loans = active_loans.where.not(id: refinanced_from_id)
    end

    if active_loans.exists?
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

  def deduct_bank_charge_from_savings
    return if bank_charges.to_d <= 0

    Saving.create!(
      member: member,
      loan: self,
      user_id: user_id,
      amount: -bank_charges.to_d,
      transaction_type: "withdrawal",
      deposit_type: "Bank Charge",
      month: Date.current)
  end
end
