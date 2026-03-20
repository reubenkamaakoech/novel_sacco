class AppConfig < ApplicationRecord
    belongs_to :user

    def self.locked_percentage
    first&.locked_savings_percentage || 0
  end

  def self.locked_ratio
    locked_percentage.to_f / 100
  end
end
