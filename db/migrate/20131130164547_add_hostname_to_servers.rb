class AddHostnameToServers < ActiveRecord::Migration
  def change
    add_column :servers, :hostname, :string
  end
end
