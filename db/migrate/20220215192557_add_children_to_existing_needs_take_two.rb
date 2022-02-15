class AddChildrenToExistingNeedsTakeTwo < ActiveRecord::Migration[6.1]
  def up
    Need.includes(:age_ranges).find_each do |need|
      range_i = 0
      age_ranges = need.age_ranges
      need.read_attribute(:number_of_children).times do
        j = age_ranges[range_i]
        need.children.create!(
          age: rand(j.min..j.max),
          sex: rand(0..1),
          notes: "Child automatically created from migration"
        )
        range_i += 1
        if range_i > age_ranges.size - 1
          range_i = 0
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
