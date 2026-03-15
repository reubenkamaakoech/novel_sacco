class Loan < ApplicationRecord
  belongs_to :member
  has_many :loan_repayments, dependent: :destroy
  
  validate :single_active_loan, on: :create   # <-- this is the new validation
  # Prevent status being set to true if loan is fully repaid
  before_update :prevent_reopening_fully_paid_loan, if: :status_changed?
  
  validate :member_must_be_active

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
  left_joins(:loan_repayments)
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
    (total_loans||0) - loan_repayments_total
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
    locked_savings = total_savings * 0.25
    available_for_loans = total_savings - locked_savings

    if amount.present? && amount > available_for_loans
      errors.add(:amount, "cannot be more than available amount (#{available_for_loans})")
    end
  end
end
