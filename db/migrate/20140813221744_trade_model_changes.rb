class TradeModelChanges < ActiveRecord::Migration
  def change
  	add_column :trades, :status, :string
  	add_column :trades, :users, :integer
  	add_column :trades, :approvals, :integer

  	create_table :trade_approvals do |t|
      t.references :trade, index: true
      t.references :user, index:true
      t.boolean :approved
      t.timestamps
     end
  end
end
