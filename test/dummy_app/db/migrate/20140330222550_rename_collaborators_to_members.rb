class RenameCollaboratorsToMembers < ActiveRecord::Migration
  def up
    ProjectUser.where(role: "collaborator").each { |c| c.role = "member"; c.save! }
  end

  def down
    ProjectUser.where(role: "member").each { |c| c.role = "collaborator"; c.save! }
  end
end
