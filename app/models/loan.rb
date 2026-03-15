class Loan < ApplicationRecord
  belongs_to :member
  has_many :loan_repayments, dependent: :destroy
  
  # Callback to auto-disable loan if fully repaid
  before_save :disable_if_fully_repaid
  
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
      .having("SUM(loan_repayments.amount) < loans.amount")
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
  def disable_if_fully_repaid
    self.status = false if balance <= 0
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
