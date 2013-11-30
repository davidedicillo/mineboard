class AddServerIdToStats < ActiveRecord::Migration
  def change
    add_column :stats, :server_id, :integer
  end
end
