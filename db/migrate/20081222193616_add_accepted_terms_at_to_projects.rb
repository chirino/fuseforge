class AddAcceptedTermsAtToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :accepted_terms_at, :datetime
  end

  def self.down
    remove_column :projects, :accepted_terms_at
  end
end
