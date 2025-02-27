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

  deliver_by :action_cable do |config|
    config.message = ->(notification) {
      {
        html: ApplicationController.render(partial: "notifications/notification", locals: {notification: notification}),
      }
    }
  end

  deliver_by :slack do |config|
    config.url = Rails.application.credentials.dig(:slack, :webhook_url)
    config.json = ->(notification) {
      {
        text: notification.message,
        attachments: [
          {
            text: "View in the app",
            fallback: "View in the app",
            actions: [
              {
                type: "button",
                text: "View",
                url: notification.url,
              }
            ]
          }
        ]
      }
    }
  end

  required_params :message

  def url
    # You can use any URL helpers here such as:
    # post_path(params[:post])
    root_path
  end
end
