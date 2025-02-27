class Avo::Actions::ProcessWebhook < Avo::BaseAction
  self.name = "Process Webhook"
  self.no_confirmation = true

  # self.visible = -> do
  #   true
  # end

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      case record.controller_name
        when "InboundWebhooks::AttioController"
          InboundWebhooks::AttioJob.perform_later(record)
        when "InboundWebhooks::EasybillController"
          InboundWebhooks::EasybillJob.perform_later(record)
        when "InboundWebhooks::PipedriveController"
          InboundWebhooks::PipedriveJob.perform_later(record)
        when "InboundWebhooks::LemlistController"
          InboundWebhooks::LemlistJob.perform_later(record)
        when "InboundWebhooks::BreakcoldController"
          InboundWebhooks::BreakcoldJob.perform_later(record)
        else
          Rails.logger.error "Unknown controller_name: #{record.controller_name}"
      end
    end
  end
end
