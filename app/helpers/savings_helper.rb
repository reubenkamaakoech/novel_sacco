module SavingsHelper
    def member_statement_rows(statements)
        running_total = 0
      statements.order(:created_at).map do |saving|
        running_total += saving.amount
          [saving, running_total]
      end
    end
end
