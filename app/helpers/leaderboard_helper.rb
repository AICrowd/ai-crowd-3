module LeaderboardHelper
  def leaderboard_ranking_change(leaderboard)
    if leaderboard.previous_row_num.blank? ||
         leaderboard.previous_row_num == 0 ||
         leaderboard.previous_row_num == leaderboard.row_num

      return image_tag(
        "icon-change-none.svg",
        data: { toggle: 'tooltip' },
        title: 'No change')
    end

    if leaderboard.row_num > leaderboard.previous_row_num
      return image_tag("icon-change-down.svg",
        data:  { toggle: 'tooltip' },
        title: "-#{leaderboard.row_num - leaderboard.previous_row_num} change, previous rank #{leaderboard.previous_row_num}")
    end

    if leaderboard.row_num < leaderboard.previous_row_num && leaderboard.previous_row_num != 0
      return image_tag(
        "icon-change-up.svg",
        data:  { toggle: 'tooltip' },
        title: "+#{leaderboard.previous_row_num - leaderboard.row_num} change, previous rank #{leaderboard.previous_row_num}")
    end
  end

  def leaderboard_participants(leaderboard)
    temp_participants = begin
      if leaderboard.try(:submitter_type) == 'Team'
        leaderboard&.team&.participants&.to_a
      else
        [leaderboard&.participant]
      end
    end

    temp_participants = [] if temp_participants.nil? || temp_participants.include?(nil)
    return temp_participants
  end

  def leaderboard_formatted_value(leaderboard_config, value)
    if value.to_i.to_s == value || value.to_f.to_s == value || value.is_a?(Numeric)
      if leaderboard_config.present?
        return format("%.#{leaderboard_config.score_precision}f", value || 0)
      else
        return format("%.3f", value || 0)
      end
    elsif value.present?
      return value
    else
      return 0
    end
  end

  def leaderboard_other_scores_array(leaderboard, leaderboard_config)
    other_scores = []
    leaderboard_config.other_scores_fieldnames_array.map(&:to_s).each do |fname|
      other_scores << if (leaderboard.meta) && (leaderboard.meta.key? fname)
                        (leaderboard.meta[fname].nil? ? "-" : leaderboard_formatted_value(leaderboard_config, leaderboard.meta[fname]))
                      elsif leaderboard.is_a?(Leaderboard) && leaderboard.submission.has_attribute?(fname) && leaderboard.submission[fname].present?
                        leaderboard_formatted_value(leaderboard_config, leaderboard.submission[fname])
                      elsif leaderboard.is_a?(Submission) && leaderboard.has_attribute?(fname) && leaderboard[fname].present?
                        leaderboard_formatted_value(leaderboard_config, leaderboard[fname])
                      else
                        '-'
                      end
    end
    return other_scores
  end

  def leaderboard_meta_challenge_other_scores_array(leaderboard, leaderboard_config, participant_id)
    other_scores = []
    leaderboard_config.other_scores_fieldnames_array.map(&:to_s).each do |fname|
      if leaderboard.meta && (leaderboard.meta.key? fname) && (leaderboard.meta[fname]) && (leaderboard.meta[fname].key? 'position')
        other_scores << leaderboard.meta[fname]
      else
        other_scores << {'position': '-', 'score': '-'}
      end
    end
    return other_scores
  end

  def rank_wise_trophy(index)
    case index
    when 0
      'gold'
    when 1
      'silver'
    when 2
      'bronze'
    end
  end

  def is_selected_country?(country)
    params[:country_name] == country
  end

  def is_selected_affiliation?(affiliation)
    params[:affiliation] == affiliation
  end

  def uniform_submissions(submissions_by_day, current_round)
    graph_date_range = current_round.start_dttm.to_date..graph_end_date(current_round)
    graph_date_range.each do |day|
      submissions_by_day[day] = 0 if !submissions_by_day.include?(day)
    end
    submissions_by_day
  end

  def submission_trend_attributes(id, current_round, width, uniform_submissions)
    {
      xmin: current_round.start_dttm.to_date,
      xmax: graph_end_date(current_round), min: 0, max: max_submissions_in_a_day(uniform_submissions),
      curve: true, width: width, height: "50px",
      points: uniform_submissions.count == 1, id: "chart-#{id}",
      library: {  tooltips: { caretSize: 0, titleFontSize: 9, bodyFontSize: 9,
                              bodySpacing: 0, titleSpacing: 0, xPadding: 2, yPadding: 2
                  },
                  scales: {
                            yAxes: [{ gridLines: { display: false }, ticks: { display: false } }],
                            xAxes: [{ gridLines: { display: false }, ticks: { display: false } }]
                  }
      }
    }
  end

  def graph_end_date(current_round)
    [Time.now.to_date, current_round.end_dttm.to_date].min
  end

  def max_submissions_in_a_day(uniform_submissions)
    uniform_submissions.values.max
  end

  def freeze_time(challenge_round, leaderboard)
    time = challenge_round.end_dttm - leaderboard.freeze_duration.to_i.hours
    time.strftime("%B %d, %Y, %H:%M %Z")
  end

  def participate_challenge_problems(challenge, participant)
    if challenge.ml_challenge?
      challenge_participant = participant.challenge_participants.find_by(challenge_id: challenge.id)
      day_num = (Time.now.to_date - challenge_participant.challenge_rules_accepted_date.to_date).to_i + 1
      return challenge.challenge_problems.where("occur_day <= ?", day_num)
    end
    return @challenge.challenge_problems
  end
end
