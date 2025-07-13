class Site < ApplicationRecord
    belongs_to :user
    has_many :attendances, dependent: :destroy  
    has_many :employees, dependent: :destroy
    has_many :payrolls, dependent: :destroy
    has_many :advances, dependent: :destroy
end
