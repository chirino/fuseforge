class CreateProjectMaturities < ActiveRecord::Migration
  def self.up
    create_table :project_maturities do |t|
      t.string :name
      t.string :description
      t.integer :position

      t.timestamps
    end
    
    ProjectMaturity.create(:name => 'Proposal')
    ProjectMaturity.create(:name => 'Planning')
    ProjectMaturity.create(:name => 'Pre-Alpha')
    ProjectMaturity.create(:name => 'Alpha')
    ProjectMaturity.create(:name => 'Beta')
    ProjectMaturity.create(:name => 'Production')
  end

  def self.down
    drop_table :project_maturities
  end
end
