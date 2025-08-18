json.extract! loan, :id, :member_id, :available_amount, :amount, :payment_period_months, :repayment_amount_per_month, :created_at, :updated_at
json.url loan_url(loan, format: :json)
