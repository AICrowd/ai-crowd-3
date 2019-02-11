require 'rails_helper'

feature "download dataset links" do
  let!(:challenge) { create :challenge, :running }
  let!(:challenge_rules) {
    create :challenge_rules,
    challenge: challenge
  }
  let!(:participation_terms) {
    create :participation_terms
  }
  let!(:participant) { create :participant }
  let!(:challenge_participant) {
    create :challenge_participant,
    challenge: challenge,
    participant: participant
  }
  let!(:admin) { create :participant, :admin }
  let!(:challenge_admin_participant) {
    create :challenge_participant,
    challenge: challenge,
    participant: admin
  }
  let!(:organizer) { create :participant, organizer: challenge.organizer }
  let!(:challenge_organizer_participant) {
    create :challenge_participant,
    challenge: challenge,
    participant: organizer
  }
  context 'download link' do
    scenario 'participant' do
      log_in(participant)
      visit challenge_dataset_files_path(challenge, wait: 1)
      expect(page).not_to have_link 'delete'
    end
    scenario 'admin' do
      log_in(admin)
      visit challenge_dataset_files_path(challenge, wait: 1)
      expect(page).to have_link 'delete'
    end
    scenario 'organizer' do
      log_in(organizer)
      visit challenge_dataset_files_path(challenge, wait: 1)
      expect(page).to have_link 'delete'
    end
    scenario 'download file', js: true do
      log_in(admin)
      visit challenge_dataset_files_path(challenge, wait: 1)
      click_link 'first_file'
      expect(DatasetFileDownload.count).to eq(1)
    end
  end

end
