namespace :import do
  
  desc 'Imports users from local csv'
  task users: :environment do
    filename = File.join Rails.root, 'users.csv'
    import = User::Import.new file: File.open(filename)
    import.process!
    puts "Total users imported: #{import.imported_count}"
    puts import.errors.full_messages if import.errors.any?
  end
end