module Challenges
  module ImportConstants
    IMPORTABLE_FIELDS = [
      :challenge,
      :status_cd,
      :tagline,
      :perpetual_challenge,
      :answer_file_s3_key,
      :slug,
      :submission_license,
      :api_required,
      :media_on_leaderboard,
      :online_grading,
      :description_markdown,
      :description,
      :evaluation_markdown,
      :evaluation,
      :rules_markdown,
      :rules,
      :prizes_markdown,
      :prizes,
      :resources_markdown,
      :resources,
      :submission_instructions_markdown,
      :submission_instructions,
      :license_markdown,
      :license,
      :dataset_description_markdown,
      :dataset_description,
      :dynamic_content_flag,
      :dynamic_content,
      :dynamic_content_tab,
      :winner_description_markdown,
      :winner_description,
      :winners_tab_active,
      :clef_challenge,
      :submissions_page,
      :private_challenge,
      :show_leaderboard,
      :grader_identifier,
      :online_submissions,
      :grader_logs,
      :require_registration,
      :grading_history,
      :post_challenge_submissions,
      :submissions_downloadable,
      :dataset_note_markdown,
      :dataset_note,
      :discussions_visible,
      :require_toc_acceptance,
      :toc_acceptance_text,
      :toc_acceptance_instructions,
      :toc_acceptance_instructions_markdown,
      :toc_accordion,
      :dynamic_content_url,
      :prize_cash,
      :prize_travel,
      :prize_academic,
      :prize_misc,
      :latest_submission,
      :other_scores_fieldnames,
      :teams_allowed,
      :max_team_participants,
      :team_freeze_seconds_before_end,
      :hidden_challenge,
      :team_freeze_time,
      :clef_task_id
    ].freeze

    IMPORTABLE_ASSOCIATIONS = {
      dataset_files_attributes: [
        :seq,
        :description,
        :dataset_file_s3_key,
        :evaluation,
        :title,
        :hosting_location,
        :external_url,
        :visible,
        :external_file_size
      ],
      submission_file_definitions_attributes: [
        :seq,
        :submission_file_description,
        :filetype_cd,
        :file_required,
        :submission_file_help_text
      ],
      challenge_partners_attributes: [
        :partner_url
      ],
      challenge_rules_attributes: [
        :terms,
        :terms_markdown,
        :instructions,
        :instructions_markdown,
        :has_additional_checkbox,
        :additional_checkbox_text,
        :additional_checkbox_text_markdown,
        :version
      ],
      challenge_rounds_attributes: [
        :challenge_round,
        :active,
        :submission_limit,
        :submission_limit_period_cd,
        :start_dttm,
        :end_dttm,
        :minimum_score,
        :minimum_score_secondary,
        :ranking_window,
        :ranking_highlight,
        :score_precision,
        :score_secondary_precision,
        :leaderboard_note_markdown,
        :leaderboard_note,
        :score_title,
        :score_secondary_title,
        :primary_sort_order_cd,
        :secondary_sort_order_cd
      ]
    }.freeze

    IMPORTABLE_IMAGES = [
      :image_file,
      challenge_partners: :image_file
    ]
  end
end