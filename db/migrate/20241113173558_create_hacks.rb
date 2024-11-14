class CreateHacks < ActiveRecord::Migration[7.0]
  def change
    create_table :hacks do |t|
      t.references :article, null: false, foreign_key: true
      t.string :title
      t.text :summary
      t.text :justification
      t.text :free_description
      t.text :premium_description
      t.text :steps_summary
      t.text :resources_needed
      t.text :expected_benefits
      t.string :extended_title
      t.text :detailed_steps
      t.text :additional_tools_resources
      t.text :case_study

      t.timestamps
    end
  end
end
