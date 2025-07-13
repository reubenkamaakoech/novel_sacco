class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :attendances, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :payrolls, dependent: :destroy
  has_many :advances, dependent: :destroy
  has_many :sites, dependent: :destroy
end
