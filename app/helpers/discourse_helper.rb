module DiscourseHelper
  def discourse_category_url(slug)
    "#{ENV['DISCOURSE_DOMAIN_NAME']}/c/#{slug}"
  end

  def discourse_new_topic_url(category_slug)
    "#{ENV['DISCOURSE_DOMAIN_NAME']}/new-topic?category=#{category_slug}"
  end

  def discourse_topic_url(slug)
    "#{ENV['DISCOURSE_DOMAIN_NAME']}/t/#{slug}"
  end

  def discourse_post_url(topic_slug, topic_id, post_number)
    "#{ENV['DISCOURSE_DOMAIN_NAME']}/t/#{topic_slug}/#{topic_id}/#{post_number}"
  end

  def discourse_user_url(username)
    "#{ENV['DISCOURSE_DOMAIN_NAME']}/u/#{username}"
  end

  def discourse_time_ago(datetime)
    time_ago_in_words = time_ago_in_words(datetime)

    if time_ago_in_words == '1 day'
      'Yesterday'
    else
      "#{time_ago_in_words.capitalize} ago"
    end
  end

  def discourse_original_poster(topic)
    topic['posters'].find { |poster| poster['description'].include?('Original Poster') }
  end
end
