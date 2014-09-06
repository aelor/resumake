class CreateJoinTableResumesUsers < ActiveRecord::Migration
  def change
    create_join_table :resumes, :users do |t|
      # t.index [:resume_id, :user_id]
      # t.index [:user_id, :resume_id]
    end
  end
end
