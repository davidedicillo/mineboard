class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :ip
      t.string :user
      t.string :password

      t.timestamps
    end
  end
end
