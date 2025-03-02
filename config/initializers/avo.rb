# For more information regarding these settings check out our docs https://docs.avohq.io
Avo.configure do |config|
  ## == Routing ==
  config.root_path = "/manage"
  # used only when you have custom `map` configuration in your config.ru
  # config.prefix_path = "/internal"

  # Where should the user be redirected when visting the `/avo` url
  config.home_path = defined?(Avo::Pro) ? "/manage/dashboards/overview" : nil

  ## == Licensing ==
  # Add your license key here for Pro or Advanced licenses
  config.license_key = ENV['AVO_LICENSE_KEY']

  ## == Set the context ==
  config.set_context do
    # Return a context object that gets evaluated in Avo::ApplicationController
    {}
  end

  ## == Authentication ==
  config.current_user_method = :current_user
  # config.authenticate_with do
  # end

  ## == Authorization ==
  config.authorization_methods = {
    index: 'index?',
    show: 'show?',
    edit: 'edit?',
    new: 'new?',
    update: 'update?',
    create: 'create?',
    destroy: 'destroy?',
    search: 'search?',
  }
  config.raise_error_on_missing_policy = false
  config.authorization_client = :pundit

  ## == Localization ==
  # config.locale = 'en-US'

  ## == Resource options ==
  # config.resource_controls_placement = :right
  # config.model_resource_mapping = {}
  # config.default_view_type = :table
  config.per_page = 100
  config.per_page_steps = [100, 200, 300]
  config.via_per_page = 100
  config.id_links_to_resource = true
  # config.cache_resources_on_index_view = true
  ## permanent enable or disable cache_resource_filters, default value is false
  # config.cache_resource_filters = false
  ## provide a lambda to enable or disable cache_resource_filters per user/resource.
  # config.cache_resource_filters = ->(current_user:, resource:) { current_user.cache_resource_filters?}

  ## == Customization ==
  config.app_name = 'ERP'
  # config.timezone = 'UTC'
  # config.currency = 'USD'
  # config.hide_layout_when_printing = false
  config.full_width_container = true
  config.full_width_index_view = true
  # config.search_debounce = 300
  # config.view_component_path = "app/components"
  # config.display_license_request_timeout_error = true
  # config.disabled_features = []
  # config.tabs_style = :tabs # can be :tabs or :pills
  # config.buttons_on_form_footers = true
  # config.field_wrapper_layout = true

  ## == Branding ==
  config.branding = {
    colors: {
      background: "#f1f5f9",
      100 => "#CEE7F8",
      400 => "#399EE5",
      500 => "#0886DE",
      600 => "#066BB2",
    },
    chart_colors: ["#0B8AE2", "#34C683", "#2AB1EE", "#34C6A8"],
    logo: "/logo.svg",
    logomark: "/mark.svg",
    placeholder: "/avo-assets/placeholder.svg",
    favicon: "/favicon.ico"
  }

  ## == Breadcrumbs ==
  config.display_breadcrumbs = true
  config.set_initial_breadcrumbs do
    add_breadcrumb "Home", '/manage'
  end

  ## == Menus ==
  config.main_menu = -> {
    group "ERP", collapsable: true, collapsed: true do
      link "Home", path: "/root"
      link "Admin", path: "/admin"
      link "Events", path: "/admin/events"
      link "Jobs", path: "/admin/jobs"
      if Rails.env.development?
        link "Jumpstart Config", path: Avo::Current.view_context.main_app.jumpstart_path
      end
    end

    group "Dashboards", icon: "dashboards", collapsable: true, collapsed: true do
      all_dashboards
    end

    group "Users", icon: "heroicons/outline/user-group", collapsable: true, collapsed: true do
      # resource :announcement
      resource :user
      resource :account
      resource :account_user
      # resource :plan
    end

    # section "Pay", icon: "heroicons/outline/currency-dollar" do
    #   resource :customer
    #   resource :charge
    #   resource :payment_method
    #   resource :subscription
    # end

    resource :persona
    resource :task
    resource :event

    group "Pipedrive", icon: "heroicons/outline/currency-dollar" do
      resource :pipedrive_crm_field, label: "Fields"
      resource :pipedrive_crm_deal, label: "Deals"
      resource :pipedrive_crm_person, label: "People"
      resource :pipedrive_crm_company, label: "Companies"
      resource :pipedrive_crm_user, label: "Users"
    end

    group "Breakcold", icon: "heroicons/outline/currency-dollar" do
      resource :breakcold_person, label: "People"
      resource :breakcold_company, label: "Companies"
      resource :breakcold_list, label: "Lists"
      resource :breakcold_tag, label: "Tags"
      resource :breakcold_status, label: "Status"
    end

    group "Lemlist", icon: "heroicons/outline/currency-dollar" do
      resource :lemlist_campaign, label: "Campaigns"
      resource :lemlist_lead, label: "Leads"
    end

    group "LinkedIn", icon: "heroicons/outline/linkedin" do
      resource :linkedin_invite, label: "Invites"
    end

    group "Integrations", icon: "heroicons/outline/puzzle" do
      resource :inbound_webhook
    end

  }
  config.profile_menu = -> {
    link "Profile", path: "/avo/profile", icon: "user-circle"
  }
end
