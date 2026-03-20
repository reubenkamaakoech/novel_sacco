class Member < ApplicationRecord
    belongs_to :user
    has_many :savings, dependent: :destroy
    has_many :loans, dependent: :destroy
    has_many :loan_repayments, through: :loans
    has_one_attached :passport_photo

    before_create :set_membership_number

    def self.locked_percentage
      AppConfig.first&.locked_savings_percentage.to_d || 0
    end

    def self.locked_ratio
      locked_percentage / 100
    end

    def total_savings
     savings.sum(:amount)
   end

   def locked_savings
     total_savings * self.class.locked_ratio 
   end

   def available_for_loans
     total_savings - locked_savings
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
