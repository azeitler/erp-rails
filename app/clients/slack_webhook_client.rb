# SlackWebhookClient
#
# The SlackWebhookClient class is a wrapper around Slack's webhook API.
# It allows you to send messages to a Slack channel via a webhook.
# The class inherits from the ApplicationClient, which is a custom class
# for handling HTTP requests.
#
# == Initialization
#
# To initialize an instance of the SlackWebhookClient class, you must
# provide a valid Slack webhook URL.
#
#   webhook_url = "https://hooks.slack.com/services/your_token_here"
#   client = SlackWebhookClient.new(webhook_url: webhook_url)
#
# Example:
#
#   client.post_message(
#     text: "Hello, world!",
#     attachments: [{title: "My Title", text: "Sample attachment."}],
#     blocks: [{type: "section", text: {type: "mrkdwn", text: "*Hello, world!*"}}]
#   )
#

class SlackWebhookClient < WebhookClient
end
