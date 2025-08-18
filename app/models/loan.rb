class Loan < ApplicationRecord
  belongs_to :member
  has_many :loan_repayments, dependent: :destroy

  validates :payment_period_months, numericality: { 
    only_integer: true, 
    greater_than: 0, 
    less_than_or_equal_to: 6 
  }

  validate :amount_cannot_exceed_available

  def member_name
    member.name   # assuming members table has a "name" column
  end

  private

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
