class Employee < ApplicationRecord
  belongs_to :user
  has_many :attendances, dependent: :destroy
  has_many :advances, dependent: :destroy
  has_many :payrolls, dependent: :destroy
  has_many :sites, dependent: :destroy

  validates :full_name, presence: true
  validates :job_category, presence: true
  validates :daily_pay, presence: true, numericality: { greater_than: 0 }

  # optional: if you want predefined categories
  JOB_CATEGORIES = ["Painter", "Sander", "Wallmaster", "Cleaner", "Sub-Contractor" ]

  def self.categories
    JOB_CATEGORIES
  end
end
