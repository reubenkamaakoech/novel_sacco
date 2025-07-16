class Payroll < ApplicationRecord
  belongs_to :user
  belongs_to :employee
  has_many :attendances, through: :employee
  
def self.generate_for_employee_and_month(employee, period)
  start_date = Date.strptime(period, "%Y-%m").beginning_of_month
  end_date = start_date.end_of_month

  # Only consider attendances with a valid site
  valid_attendances = Attendance.where(
    employee: employee,
    work_date: start_date..end_date
  ).where.not(site_id: nil)

  worked_days = valid_attendances.count
  total_pay = worked_days * employee.daily_pay.to_f

  # Find or create payroll
  payroll = Payroll.find_or_initialize_by(employee: employee, period: period)
  payroll.worked_days = worked_days
  payroll.total_pay = total_pay

  # Optional: recalculate advances if applicable
  payroll.advance = Advance.where(employee: employee, date: start_date..end_date).sum(:amount)
  payroll.payable = total_pay - payroll.advance.to_f

  payroll.save
end

end