class Employee < ApplicationRecord
  belongs_to :user
  has_many :attendances, dependent: :destroy
  has_many :advances, dependent: :destroy
  has_many :payrolls, dependent: :destroy
  has_many :sites, dependent: :destroy
  has_many :payrolls, through: :attendances
  
end
