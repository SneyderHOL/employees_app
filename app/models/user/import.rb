class User::Import
  include ActiveModel::Model
  attr_accessor :file, :imported_count

  def process!
    @imported_count = 0
    line = 0
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      line += 1;
      user = User.assign_from_row(row)
      if user.save
        @imported_count += 1
      else
        # errors.add(:base, "Line #{$.} - #{user.errors.full_messages.join(', ')}")
        errors.add(:base, "Line #{line} - #{user.errors.full_messages.join(', ')}")
      end
    end
  end

  def save
    process!
    errors.none?
  end
end