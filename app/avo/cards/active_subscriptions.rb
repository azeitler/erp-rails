class Avo::Cards::ActiveSubscriptions < Avo::Cards::MetricCard
  self.id = "active_subscriptions"
  self.label = "Active subscriptions"
  self.description = "Total number of active subscriptions"

  def query
    result ::Pay::Subscription.active.count
  end
end
