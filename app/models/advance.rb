class Advance < ApplicationRecord
  belongs_to :user
  belongs_to :employee

  after_save :update_payroll

  private

  def update_payroll
    Payroll.generate_for_employee_and_month(employee, date.strftime("%Y-%m"))
  end
end
