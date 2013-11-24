class SpnController < ApplicationController
	skip_before_filter :verify_authenticity_token
	before_filter :find_user_from_header, only: %w(create destroy)

	def log
		logger.info "SPN Error: #{request.body.read}"
		render text: ''
	end

	def download
		response.content_type = 'application/zip'
		j = JSON.parse request.body.read
		send_data Spn::Packager.new(authentication_token: j['token']).content
	end

	def create
		@spn = user.spns.device_token(params[:device_token]).first_or_create(
				device_token: params[:device_token])
		render text: ''
	end

	def destroy
		@spn = user.spns.device_token(params[:device_token]).first
		@spn.destroy if @spn.present?
		render text: ''
	end

	private
	def find_user_from_header
		token = token_from_http_authorization_header
		raise "Token not found." unless token.present?
		@user = User.find_by_spn_token(token) || raise("User not found.")
	end
	def token_from_http_authorization_header
		auth_header = request.headers['HTTP_AUTHORIZATION']
		return nil unless auth_header.present?
		return nil unless auth_header =~ /^ApplePushNotifications (.+)$/
		$1
	end
	def user; @user end
end
