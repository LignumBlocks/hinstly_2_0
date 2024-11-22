class AddFieldsToHacks < ActiveRecord::Migration[7.0]
  def change
    add_column :hacks, :is_advise, :boolean, default: false
    add_column :hacks, :advise_justification, :string, default: ''
  end
end
