json.extract! loan_repayment, :id, :user_id, :loan_id, :member_id, :amount, :created_at, :updated_at
json.url loan_repayment_url(loan_repayment, format: :json)
