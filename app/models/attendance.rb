class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :employee
  belongs_to :site, optional: true
  
  
  validates :employee_id, uniqueness: { scope: :work_date, message: "already has attendance for this date" }
  validates :work_date, presence: true

   after_save :update_payroll

  private

  def update_payroll
    Payroll.generate_for_employee_and_month(employee, work_date.strftime("%Y-%m"))
  end
end
