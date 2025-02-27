# To deliver this notification:
#
# LinkedinInviteAccepted.with(post: @post).deliver(current_user)

class LinkedinInviteAcceptedNotifier < ApplicationNotifier
  # Add your delivery methods, for example:
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end

  # deliver_by :action_cable do |config|
  #   config.message = ->(notification) {
  #     {
  #       # Filters notification client side to the user's current account. Removing this always renders the notification.
  #       account_id: notification.account_id,
  #       html: ApplicationController.render(partial: "notifications/notification", locals: {notification: notification}),
  #     }
  #   }
  # end

  deliver_by :slack do |config|
    config.url = Rails.application.credentials.dig(:slack, :webhook_url)
    config.json = -> () {
      {
        # "fallback": "fallback", # params[:sender],

        # "pretext": "pretext", # params[:sender],
        "text": params[:sender],

        "color": "#0000ff",

        "fields": [
          {
            "title": params[:message],
            "value": params[:intro],
            "short": false
          }
        ]
      }
    }
    config.raise_if_not_okay = true
  end

  required_params :message, :sender, :intro

  def message
    params[:message]
  end

  def url
    # You can use any URL helpers here such as:
    # post_path(params[:post])
    root_path
  end
end
