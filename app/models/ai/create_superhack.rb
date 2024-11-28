module Ai
  class CreateSuperhack
    def self.group_by_financial_goal
      financial_goals_classification = Classification.find_by(name: 'Financial Goals')
      financial_goal_categories = financial_goals_classification.categories.includes(:hacks)
      grouped_hacks = financial_goal_categories.each_with_object({}) do |category, hash|
        hash[category.name] = category.hacks.map do |hack|
          {
            id: hack.id,
            free_title: hack.free_title,
            description: hack.description,
            main_goal: hack.main_goal,
            steps_summary: hack.steps_summary,
            expected_benefits: hack.expected_benefits
          }
        end
      end

      # Save grouped hacks to JSON
      save_to_json_file(grouped_hacks)
    end

    def self.save_to_json_file(data)
      # Define the file path
      file_path = Rails.root.join('storage', 'exports', 'financial_goal_hacks.json')

      # Ensure the directory exists
      FileUtils.mkdir_p(File.dirname(file_path))

      # Write the JSON data
      File.open(file_path, 'w') do |file|
        file.write(JSON.pretty_generate(data))
      end

      Rails.logger.info("Financial Goal Hacks exported to #{file_path}")
    end
  end
end
