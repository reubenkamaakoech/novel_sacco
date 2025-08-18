json.extract! member, :id, :membership_number, :name, :id_number, :monthly_contribution, :phone_number, :email, :join_date, :status, :next_of_kin_name, :next_of_kin_contact, :created_at, :updated_at
json.url member_url(member, format: :json)
