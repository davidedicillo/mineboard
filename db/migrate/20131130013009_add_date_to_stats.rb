class AddDateToStats < ActiveRecord::Migration
  def change
    add_column :stats, :date, :datetime
    add_column :stats, :primes, :integer
    add_column :stats, :tests, :integer
    add_column :stats, :fivechains, :integer
    add_column :stats, :chains, :float
  end
end
