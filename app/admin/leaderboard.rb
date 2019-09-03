ActiveAdmin.register Leaderboard do
  belongs_to :challenge, parent_class: Challenge
  navigation_menu :challenge

  config.sort_order = 'row_num: :asc'

  actions :index, :show

  filter :id
  filter :submitter_type
  filter :submitter_id
  filter :name
  filter :media_content_type
  filter :submission_id
  filter :challenge_round_id

  controller do
    def scoped_collection
      super.includes :participant, :team, :challenge_round
    end
  end

  index do
    selectable_column
    column "Rank" do |res|
      res.row_num
    end
    column :id
    column :challenge_round_id
    column "Round" do |res|
      res.challenge_round.challenge_round
    end
    column :team
    column :participant
    column :name
    column "Email" do |res|
      res.participant&.email
    end
    column :score
    column :score_secondary
    column :post_challenge
    column :media_thumbnail
    column :media_large
    column :media_content_type
    column :updated_at
    actions
  end

  csv do
    column "Rank" do |res|
      res.row_num
    end
    column :id
    column :challenge_round_id
    column "Round" do |res|
      res.challenge_round.challenge_round
    end
    column :participant
    column :name
    column "Email" do |res|
      res.participant&.email
    end
    column :score
    column :score_secondary
    column :post_challenge
    column :media_thumbnail
    column :media_large
    column :media_content_type
    column :updated_at
  end
end
