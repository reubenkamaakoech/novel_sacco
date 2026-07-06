class ClosingBook < ApplicationRecord
  belongs_to :member
  belongs_to :user

  before_validation :calculate_totals
  after_commit :finalize_closure, on: :create

  private
  def calculate_totals
    self.total_savings = member.savings_balance
    self.loan_balance  = member.loan_balance

    bank_charges_due = member.outstanding_bank_charges

    self.withdrawal_charges ||= 0
    self.other_charges ||= 0

    self.amount_paid =
      total_savings -
      loan_balance -
      bank_charges_due -
      withdrawal_charges -
      other_charges
  end

  def finalize_closure
    ActiveRecord::Base.transaction do
      settle_loans
      withdraw_savings
      member.update!(status: false)
    end
  end

 

  def withdraw_savings
    # we'll put the savings withdrawal code here
  end

   def finalize_closure
    ActiveRecord::Base.transaction do
      settle_loans
      withdraw_savings
      member.update!(status: false)
    end
  end

  def settle_loans
    member.loans.where(status: true).find_each do |loan|
      next if loan.balance <= 0

      LoanRepayment.create!(
        loan: loan,
        user: user,
        amount: loan.balance,
        bank_charge_paid: loan.outstanding_bank_charge,# one-time bank charge
        repayment_date: closing_date,
        repayment_month: closing_date.beginning_of_month,
        balance_at_time: loan.balance,
        balance_after: 0
      )
      
      loan.update!(status: false)
    end
  end
 
  def withdraw_savings
    Saving.create!(
      member: member,
      user: user,
      amount: -member.savings_balance,
      transaction_type: "withdrawal",
      deposit_type: "Account Closure",
      month: closing_date
    )
  end
end
