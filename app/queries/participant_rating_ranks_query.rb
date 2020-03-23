class ParticipantRatingRanksQuery
  attr_reader :relation

  def initialize(relation = Participant.all)
    @relation = relation
  end

  def call()
    @relation.where('fixed_rating is not null').map do |participant|
      user_final_rating = UserRating.where("participant_id=#{participant.id} and rating is not null and challenge_round is not null").reorder('created_at desc').first
      time_difference = (Time.current.to_date - user_final_rating[:created_at].to_date)
      time_difference = time_difference.to_i
      total_number_of_days = 365
      updated_rating = participant.fixed_rating * (Math.exp(-time_difference/total_number_of_days))
      participant.update!({rating: updated_rating})
      UserRating.create!(participant_id: participant.id, rating: updated_rating, variation: user_final_rating['variation'], challenge_round: nil)
    end
    ranks = @relation.where('rating is not null').select('id, rank() over (order by (rating - 3*variation) desc) as current_ranking, ranking as previous_ranking, ranking_change').reorder('ranking asc')
    participant_rankings = ranks.map {|participant| {ranking: participant.current_ranking}}
    participant_rankings_change = ranks.map do |participant|
      change_in_true_ranking = participant.current_ranking - participant.previous_ranking
      if participant.previous_ranking == -1
        {'ranking_change' => 0}
      elsif  change_in_true_ranking.to_i == 0
        {'ranking_change' => participant.ranking_change.to_i}
      else
        {'ranking_change' => change_in_true_ranking.to_i}
      end
    end
    participant_ids = ranks.map {|participant| participant.id}
    Participant.update participant_ids, participant_rankings
    Participant.update participant_ids, participant_rankings_change
  end
end
