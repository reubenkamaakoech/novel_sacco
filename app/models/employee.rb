class Employee < ApplicationRecord
  belongs_to :user
  has_many :advances, dependent: :destroy

  validates :full_name, presence: true
  validates :job_category, presence: true
  validates :daily_pay, presence: true, numericality: { greater_than: 0 }

  # optional: if you want predefined categories
  JOB_CATEGORIES = ["General Manager", "Human Resources", "Administration", "Accounts", "Engineer", "Driver", "Cleaner", "Security Guard"]

  def self.categories
    JOB_CATEGORIES
  end
end
