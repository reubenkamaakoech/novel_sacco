class ChangePaymentPeriodMonthsToInteger < ActiveRecord::Migration[8.0]
   def up
    add_column :loans, :payment_period_months_tmp, :integer

    Loan.reset_column_information

    Loan.find_each do |loan|
      loan.update_column(
        :payment_period_months_tmp,
        loan.payment_period_months.to_i
      )
    end

    remove_column :loans, :payment_period_months
    rename_column :loans, :payment_period_months_tmp, :payment_period_months
  end

  def down
    change_column :loans, :payment_period_months, :string
  end
end
