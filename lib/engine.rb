module APILimitPlugin
  VERSION = '0.1.0'

  class Engine < Rails::Engine
    isolate_namespace APILimitPlugin

    # # Ensure plugin is compatible with Peatio.
    # config.before_initialize do
    # end

    # Mount new API resource in hook (friendly with development environment).
    # More about configuration stages: http://guides.rubyonrails.org/configuring.html#configuring-action-dispatch
    config.after_initialize do
      Rack::Attack.throttle 'Limit number of calls to API',
        limit:  ENV.fetch('PEATIO_API_LIMIT_NUMBER', 6000).to_i,
        period: ENV.fetch('PEATIO_API_LIMIT_PERIOD', 5.minutes).to_i do |req|
          req.env['api_v2.authentic_member_email']
        end
    end
  end
end
