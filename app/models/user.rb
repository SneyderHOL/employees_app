class User < ApplicationRecord
  enum departments: {
    accounting: "Accounting",
    finance: "Finance",
    operations: "Operations",
    security: "Security",
    human_resources: "Human Resources"
    }, _prefix: :department

  validates :first_name, presence: true, length: { minimum: 3, maximum: 50 }

  validates :last_name, presence: true, length: { minimum: 3, maximum: 50 }

  validates :phone, numericality: { only_integer: true }, length: { is: 11 }

  validates :position, length: { maximum: 50 }

  validates :salary, numericality: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX },
            length: { minimum: 5, maximum: 50 }
  
  validates :department, presence: true,
            inclusion: {
              in: departments.values,
              message: "%{value} is not a valid department"
            }

  def self.export_to_csv
    properties = %w{id first_name last_name email phone position salary department}
    CSV.generate(headers: true) do |csv|
      csv << properties

      all.each do |user|
        csv << properties.map{ |prop| user.send(prop) }
      end
    end
  end

  def self.import_from_csv(file)
    failed_to_saved = []
    counter = 0
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      user = assign_from_row(row)
      if user.save
        counter += 1
      else
        failed_to_saved.push("#{user.email} - #{user.errors.full_messages.join(', ')}")
      end
    end
    return counter if failed_to_saved.empty?
    failed_to_saved.join('\n')
  end

  def self.assign_from_row(row)
    user = where(email: row[:email]).first_or_initialize
    user.assign_attributes row.to_hash
    user
  end
end
