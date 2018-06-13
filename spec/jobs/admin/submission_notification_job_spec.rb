require 'rails_helper'
RSpec.describe Admin::SubmissionNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let(:submission) { create :submission }
  let!(:email_preference) {
    create :email_preference,
    email_frequency: :every,
    participant: submission.participant }

  subject(:job) { described_class.perform_later(submission) }

  describe 'queues the job' do

    it 'queues the job' do
      expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'is placed on the default queue' do
      expect(described_class.new.queue_name).to eq('default')
    end

    it 'executes with no errors' do
      perform_enqueued_jobs { job }
    end

    after do
      clear_enqueued_jobs
      clear_performed_jobs
    end
  end

end
