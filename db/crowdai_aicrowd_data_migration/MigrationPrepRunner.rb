if Rails.env == 'development' || Rails.env == 'staging'
  # Fetch objects from the Saved Json Files
  organizers = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/organizers.json'))['organizers']
  challenges = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/challenges.json'))['challenges']
  challenge_rounds = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/challenge_rounds.json'))['challenge_rounds']
  submissions = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/submissions.json'))['submissions']
  challenge_participants = JSON.parse(File.read('db/crowdai_aicrowd_data_migration/challenge_participants.json'))['challenge_participants']

  ActiveRecord::Base.transaction do
    # For each Organizer 'org'
    organizers.each do |org|
      # Remove ID from Hash so that we get a new ID
      org_old_id = org['id']
      org['id'] = nil
      # Add Tagline as it is needed
      org['tagline'] ||= org['organizer']
      # Create a new organizer from Hash
      loop_organizer = Organizer.create!(org)
      # Select all the challenges for org
      selected_chals = challenges.select { |c| c['organizer_id'] == org_old_id }

      selected_chals.each do |chal|
        chal_old_id = chal["id"]
        chal.delete("id")
        chal.delete("featured_sequence")
        chal.delete("submission_count")
        chal["organizer_id"] = loop_organizer.id
        chal["prize_cash"] = ""
        chal["prize_academic"] = ""
        chal["prize_misc"] = ""

        # create a new challenge
        loop_challenge = Challenge.create!(chal)

        # Select all rounds for current challenge
        selected_chal_rounds = challenge_rounds.select { |cr| cr['challenge_id'] == chal_old_id }

        selected_chal_rounds.each do |chal_round|
          old_chal_round_id = chal_round["id"]
          chal_round.delete("id")
          chal_round["challenge_id"] = loop_challenge.id
          chal_round["submission_limit"] = 5
          chal_round["submission_limit_period"] = "day"

          loop_challenge_round = ChallengeRound.create!(chal_round)

          selected_chal_participants = challenge_participants.select { |cp| cp['challenge_id'] == chal_old_id }

          selected_chal_participants.each do |chal_participant|
            old_participant_id = chal_participant["participant_id"]
            chal_participant.delete("id")
            chal_participant.delete("participant_id")
            chal_participant["challenge_id"] = loop_challenge.id
            chal_participant["name"] = "Unknown User"

            loop_challenge_participant = ChallengeParticipant.create!(chal_participant)

            MigrationMapping.create!(
                source_type: 'ChallengeParticipant',
                source_id: loop_challenge_participant.id,
                crowdai_participant_id: old_participant_id
            )
          end

          selected_submissions = submissions.select { |s| s['challenge_round_id'] == old_chal_round_id }

          selected_submissions.each do |sub|
            old_participant_id = sub["participant_id"]
            sub.delete("id")
            sub.delete("participant_id")
            sub["challenge_id"] = loop_challenge.id
            sub["challenge_round_id"] = loop_challenge_round.id
            if sub["meta"].is_a? Hash
              sub["meta"]["private_ignore-leaderboard-job-computation"] = true
            else
              sub["meta"] = { "private_ignore-leaderboard-job-computation": true }
            end

            loop_submission = Submission.create!(sub)

            MigrationMapping.create!(
                source_type: 'Submission',
                source_id: loop_submission.id,
                crowdai_participant_id: old_participant_id
            )
          end
        end
      end
    end
  end
end
