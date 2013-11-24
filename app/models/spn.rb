class Spn < ActiveRecord::Base
  belongs_to :user
  attr_accessible :device_token

  scope :device_token, -> token { where(device_token: token) }
  scope :by_user, -> user_id { where(user_id: user_id) }

  def self.pusher
    @@pusher = build_pusher
  end

  # params: { title: "", body: "", path: '/hello'} + optional {action: 'Read'}
  def push(params)
    n = build_notification_from_params params
    self.class.pusher.push n
  end

  private
  def build_notification_from_params(params)
    params = params.merge device_token: self.device_token
    Grocer::SafariNotification.new(params)
  end

  def self.build_pusher
    Grocer.pusher(
        certificate: ENV['PEM_PATH'],
        passphrase: ENV['PEM_PASS_PHRASE'],
        gateway: 'gateway.push.apple.com',
    )
  end
end
