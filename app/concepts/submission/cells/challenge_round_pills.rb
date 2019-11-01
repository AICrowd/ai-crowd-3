class Submission::Cell::ChallengeRoundPills < Submission::Cell

  def show
    render :challenge_round_pills if challenge_rounds.count > 1
  end

  def challenge
    model
  end

  def current_round_id
    options[:current_round_id]
  end

  def my_submissions
    options[:my_submissions]
  end

  def challenge_rounds
    challenge.challenge_rounds
  end

  def tab_class(challenge_round)
    if challenge_round.id == current_round_id
      'nav-link active'
    else
      'nav-link'
    end
  end

end
