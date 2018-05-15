ActiveAdmin.register Challenge do
  #config.filters = false

  sidebar "Challenge Configuration", only: [:show, :edit] do
    ul do
      li link_to "Dataset Files", admin_challenge_dataset_files_path(challenge)
      li link_to "Submission File Definition", admin_challenge_submission_file_definitions_path(challenge)
    end
  end

  sidebar "Challenge Details", only: [:show, :edit] do
    ul do
      li link_to "Leaderboard",   admin_challenge_leaderboards_path(challenge)
      li link_to "Submissions",   admin_challenge_submissions_path(challenge)
      li link_to "Topics", admin_challenge_topics_path(challenge)
    end
  end

  filter :id
  filter :status_cd
  filter :challenge

  index do
    selectable_column
    column :id
    column :challenge
    column :status
    column :page_views
    column :participant_count
    column :submission_count
    actions
  end

  controller do
    actions :all, except: [:edit,:new]
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
    def permitted_params
      params.permit!
    end
  end

end
