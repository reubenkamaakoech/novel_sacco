class Member < ApplicationRecord
    belongs_to :user
    has_many :savings, dependent: :destroy
    has_many :loans, dependent: :destroy
    has_many :loan_repayments, through: :loans
    has_one_attached :passport_photo
    has_one :closing_books, dependent: :destroy

    before_create :set_membership_number

    def self.locked_percentage
      AppConfig.first&.locked_savings_percentage.to_d || 0
    end

    def self.locked_ratio
      locked_percentage / 100
    end

   def total_savings
    savings
      .where(transaction_type: "deposit")
      .where.not(deposit_type: "Bank Charge Paid")
      .sum(:amount)
      .to_d
   end

   def savings_balance
    savings.sum(:amount)
   end

   def locked_savings
     total_savings * self.class.locked_ratio 
   end

   def available_for_loans
     total_savings - locked_savings
   end

   def available_savings
    savings.where(transaction_type: "deposit").sum(:amount).to_d - loan_balance
  end

  def loan_balance
    loans.where(status: true).sum do |loan|
      loan.balance + loan.outstanding_bank_charge
    end
  end

  def outstanding_bank_charges
    loans.where(status: true).sum(&:outstanding_bank_charge)
  end

  def monthly_loan_repayment
    loans.find_by(status: true)&.repayment_amount_per_month.to_d
  end

  def monthly_total
    monthly_contribution.to_d + monthly_loan_repayment
  end

  def self.total_monthly_contributions
   sum(:monthly_contribution)
  end

  def self.total_monthly_loan_repayments
   all.sum(&:monthly_loan_repayment)
  end

  def self.total_monthly_collections
    total_monthly_contributions + total_monthly_loan_repayments
  end

   private

   def set_membership_number
     return if membership_number.present?

    # Extract only numeric part from membership_number, ignoring the prefix
     last_number = Member
       .where("membership_number LIKE ?", "NS%")
       .pluck(:membership_number)
       .map { |num| num.gsub(/\D/, '').to_i } # remove non-digits
       .max

    if last_number.present?
      new_number = last_number + 1
       self.membership_number = "NS#{new_number.to_s.rjust(3, '0')}"
    else
     self.membership_number = "NS001"
    end
  end
end
