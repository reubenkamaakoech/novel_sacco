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

  # Example roles: admin, manager, staff, employee
  ROLES = %w[admin manager staff employee]

  def self.categories
    ROLES
  end

  def admin?
    role == 'admin'
  end

  def manager?
    role == "manager"
  end

  def staff?
    role == "staff"
  end

  def employee?
    role == "employee"
  end

  def can_access_data?
    access_granted?
  end

  def access_granted?
    admin? || self[:access_granted]
  end

  def active_for_authentication?
    super && status?
  end

  def inactive_message
    status? ? super : :account_inactive
  end
end
