json.extract! closing_book, :id, :member_id, :user_id, :closing_date, :total_savings, :withdrawal_charges, :other_charges, :amount_paid, :remarks, :created_at, :updated_at
json.url closing_book_url(closing_book, format: :json)
