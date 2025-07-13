json.extract! payroll, :id, :employee_id, :period, :worked_days, :total_pay, :advance, :payable, :created_at, :updated_at
json.url payroll_url(payroll, format: :json)
