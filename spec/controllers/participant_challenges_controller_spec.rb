require 'rails_helper'

RSpec.describe ParticipantChallengesController, type: :controller do
  render_views

  let!(:challenge) { create :challenge, :running }
  let!(:participant) { create :participant }
  let!(:challenge_participant) {
    create :challenge_participant,
    challenge: challenge,
    participant: participant
  }
  let!(:admin) { create :participant, :admin }
  let!(:submission) {
    create :submission,
    participant: participant,
    challenge: challenge,
    challenge_round_id: challenge.challenge_rounds.first.id }

  before do
    sign_in(admin)
  end

  describe 'GET #index challenge_running' do
    before { get :index, params: { challenge_id: challenge.id } }

    it { expect(response).to render_template :index }
  end
end
