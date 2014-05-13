class AddTotalAmountCurrencyToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :total_budget_currency, :string, default: "USD", null: false
  end
end
