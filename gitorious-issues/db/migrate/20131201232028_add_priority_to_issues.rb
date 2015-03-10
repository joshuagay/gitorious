class AddPriorityToIssues < ActiveRecord::Migration
  def change
    add_column :issues_issues, :priority, :integer, :null => false, :default => 0
  end
end
