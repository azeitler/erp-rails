class AddRequestInfoToInboundWebhooks < ActiveRecord::Migration[7.2]
  def change
    add_column :inbound_webhooks, :controller_name, :string
    add_column :inbound_webhooks, :action_name, :string
    add_column :inbound_webhooks, :ip_address, :string
    add_column :inbound_webhooks, :user_agent, :string
    add_column :inbound_webhooks, :headers, :jsonb
  end
end
