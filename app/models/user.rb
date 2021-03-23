class User < ApplicationRecord
  enum departments: { accounting: "Accounting", finance: "Finance", operations: "Operations", security: "Security", human_resources: "Human Resources" }, _prefix: :department
  validates :first_name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 3, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }, length: { minimum: 5, maximum: 50 }
  validates :phone, numericality: { only_integer: true }, length: { is: 11 }
  validates :position, length: { maximum: 50 }
  validates :salary, numericality: true
  validates :department, presence: true
end
