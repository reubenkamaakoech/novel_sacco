json.extract! employee, :id, :full_name, :daily_pay, :phone, :national_id, :created_at, :updated_at
json.url employee_url(employee, format: :json)
