class ParticipantsController < ApplicationController
  before_action :authenticate_participant!, except: [:show]
  before_action :set_participant,
    only: [:show, :edit, :update, :destroy]

  respond_to :html, :js

  def show
    @articles = Article.where(participant_id: @participant.id)
    challenge_ids = policy_scope(ParticipantChallenge)
      .where(participant_id: @participant.id)
      .pluck(:challenge_id)
    @challenges = Challenge.where(id: challenge_ids)
    @posts = @participant.comments.order(created_at: :desc)
  end

  def edit
  end

  def index
    @participants = Participant.all
  end

  def update
    @participant = Participant.friendly.find(params[:id])
    if @participant.update_attributes(participant_params)
      flash[:success] = "Profile updated"
      redirect_to @participant
    else
      render :edit
    end
  end

  def accept_terms
    @participant = Participant.friendly.find(params[:participant_id])
    @challenge = Challenge.friendly.find(params[:challenge_id])
    @participant.participation_terms_accepted_date = Time.now
    if @participant.update_attributes(accept_terms_params)
      if !policy(@challenge).has_accepted_challenge_rules?
        redirect_to [@challenge, @challenge.current_challenge_rules]
      else
        redirect_to @challenge
      end
    end
  end

  def destroy
    @participant.destroy
    redirect_to '/', notice: 'Account was successfully deleted.'
  end


  def regen_api_key
    @participant = Participant.friendly.find(params[:participant_id])
    authorize @participant
    @participant.api_key = @participant.generate_api_key
    @participant.save!
    redirect_to participant_path(@participant),notice: 'API Key regenerated.'
  end

  def sso_helper
    decoded = Base64.decode64(params[:sso])
    decoded_hash = Rack::Utils.parse_query(decoded)
    nonce = decoded_hash['nonce']
    return_sso_url = decoded_hash['return_sso_url']
    sig = params[:sig]
    signed = OpenSSL::HMAC.hexdigest("sha256", ENV['SSO_SECRET'], params[:sso])
    if(sig != signed)
      raise RuntimeError, "Incorrect SSO signature"
    end

    avatar_url = ENV['DOMAIN_NAME'] + '/1ts/users/user-avatar-default.svg'
    if current_user.image_file and not current_user.image_file.url.nil?
      avatar_url = current_user.image_file.url
    end

    response_params = {
      email: current_user.email,
      admin: current_user.admin,
      external_id: current_user.id,
      name: current_user.name,
      nonce: nonce,
      avatar_url: avatar_url
    }

    response_query = response_params.to_query
    encoded_response_query = Base64.strict_encode64(response_query)
    response_sig = OpenSSL::HMAC.hexdigest("sha256", ENV['SSO_SECRET'], encoded_response_query)

    url = File.join(return_sso_url, "?sso=#{CGI::escape(encoded_response_query)}&sig=#{response_sig}")

  end

  def sso
    authorize current_user
    url = sso_helper
    redirect_to url
  end

  def sync_mailchimp
    @job = AddToMailChimpListJob.perform_later(params[:participant_id])
    render 'admin/participants/refresh_sync_mailchimp_job_status'
  end

  def remove_image
    @participant = Participant.friendly.find(params[:participant_id])
    authorize @participant
    @participant.remove_image_file!
    @participant.save
    redirect_to edit_participant_path(@participant),
      notice: 'Image removed.'
  end

  private
  def set_participant
    @participant = Participant.friendly.find(params[:id])
    authorize @participant
  end

  def accept_terms_params
    params.require(:participant).permit(
      :participation_terms_accepted_version
    )
  end

  def participant_params
    params
      .require(:participant)
      .permit(
        :email,
        :password,
        :password_confirmation,
        :phone_number,
        :name,
        :organizer_id,
        :email_public,
        :bio,
        :website,
        :github,
        :linkedin,
        :twitter,
        :image_file,
        :affiliation,
        :address,
        :city,
        :country_cd,
        :first_name,
        :last_name,
        # NATE: we might need to allow this if for some reason a user has been created without agreeing,
        # for example during the oauth flow
        # :agreed_to_terms_of_use_and_privacy,
        :agreed_to_marketing)
    end


end
