class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.references :source, null: false, foreign_key: true
      t.string :link
      t.text :content
      t.boolean :success
      t.json :metadata

      t.timestamps
    end
  end
end
