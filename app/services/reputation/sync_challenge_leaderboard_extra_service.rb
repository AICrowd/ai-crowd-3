module Reputation
  class SyncChallengeLeaderbaordExtraService

    def initialize
    end

    def call
      last_updated_time = get_last_updated_time
      sync_data(last_updated_time)
    end

    def get_last_updated_time
      response = HTTP.get("#{ENV['RATING_SANDBOX_URL']}/contest/get_update_time", headers: {Authorization: "Bearer #{secure_data}"})
      contest = JSON.parse(response.body)
      contest["created_at"]
    end

    def secure_data
      payload = {fastapi: "aicrowd", access_key: "aicrowd_reputation_system"}
      JWT.encode(payload, ENV['REPUTATION_TOKEN'])
    end

    def sync_data(last_updated_time)
      challenge_leaderboard_extras = ChallengeLeaderboardExtra.where(ranking_enabled: true).includes(:challenge_round)
      result = []
      challenge_leaderboard_extras.each do |cle|
        if cle.challenge_round
          result << {challenge_leaderboard_extra_id: cle.id, name: cle.challenge_round.challenge_round, created_at: cle.created_at, time_seconds: cle.created_at.to_i}
        end
      end
      response = HTTP.post("#{ENV['RATING_SANDBOX_URL']}/contest/create", json: result, headers: {Authorization: "Bearer #{secure_data}"})
      if response.status
        Reputation::SyncLeaderboardService.new.call
      end
    end

  end
end