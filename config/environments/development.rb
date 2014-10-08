Rails.application.configure do
	config.cache_classes = false
	config.eager_load = false
	config.consider_all_requests_local = true
	config.action_controller.perform_caching = false
	config.action_mailer.raise_delivery_errors = false
	config.active_support.deprecation = :log
	config.active_record.migration_error = :page_load
	config.assets.debug = true
	config.assets.raise_runtime_errors = true
	config.app_domain = 'somedomain.com'
	config.action_mailer.delivery_method = :smtp
	config.action_mailer.perform_deliveries = true
	config.action_mailer.default_url_options = { host: config.app_domain }
	config.action_mailer.smtp_settings = { address: 'smtp.gmail.com', port: '587',
	                                       enable_starttls_auto: true,
	                                       user_name: 'someuser',
	                                       password: 'somepass',
	                                       authentication: :plain,
	                                       domain: 'somedomain.com' }
end

