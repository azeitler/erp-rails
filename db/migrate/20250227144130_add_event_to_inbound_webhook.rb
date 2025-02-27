class AddEventToInboundWebhook < ActiveRecord::Migration[7.2]
  def change
    add_column :inbound_webhooks, :event, :string
  end
end
