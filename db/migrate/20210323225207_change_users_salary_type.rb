class ChangeUsersSalaryType < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      change_table :users do |t|
        dir.up    { t.change :salary, :float }
        dir.down    { t.change :salary, :decimal }
      end
    end
  end
end
