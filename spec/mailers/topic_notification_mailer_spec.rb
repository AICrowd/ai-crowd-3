require 'spec_helper'

RSpec.describe TopicNotificationMailer, type: :mailer do
  describe 'methods' do
    let!(:challenge) { create :challenge }
    let!(:participant) { create :participant }
    let!(:email_preference) do
      create :email_preference,
             email_frequency: :every,
             participant:     participant
    end
    let!(:topic) { create :topic, participant: participant }

    it 'successfully sends a message' do
      res = described_class.new.sendmail(participant.id, topic.id)
      man = MandrillSpecHelper.new(res)

    ### NATE: current workaround for mandrill tests
      ### are to check that the reason the message
      ### wasn't sent was due to it being unsigned.  The
      ### mandrill test api key is on a separate account
      ### and would need more setup to be able to send.
      # expect(man.status).to eq 'sent'
      expect(man.status).to eq 'rejected'
      expect(man.reject_reason).to eq 'unsigned'
    end

    # it 'addresses the email to the participant' do
    #  res = described_class.new.sendmail(participant.id,topic.id)
    #  man = MandrillSpecHelper.new(res)
    #  expect(man.merge_var('NAME')).to eq(participant.name)
    # end

    # it 'produces a body which is correct HTML' do
    #  res = described_class.new.sendmail(participant.id,topic.id)
    #  man = MandrillSpecHelper.new(res)
    #  expect(man.merge_var('BODY')).to be_a_valid_html_fragment
    # end

    it 'produces a valid challenge link' do
      link = described_class.new.challenge_link(challenge)
      expect(link).to be_a_valid_html_fragment
      expect(link).to include(ENV['DOMAIN_NAME'])
    end
  end
end
