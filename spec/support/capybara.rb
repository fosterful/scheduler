# frozen_string_literal: true

RSpec.configure do |config|
  headless = ENV.fetch('HEADLESS', true) != 'false'

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before :each, type: :system, js: true do
    # Docker environment
    url = if headless
            "http://#{ENV['SELENIUM_REMOTE_HOST']}:4444/wd/hub"
          else
            'http://host.docker.internal:9515'
          end

    driven_by :selenium, using: :chrome, options: {
      browser:              :remote,
      url:                  url,
      desired_capabilities: :chrome
    }

    Capybara.server = :puma, { Silent: true }

    # Find Docker IP address
    Capybara.server_host = if headless
                             `/sbin/ip route|awk '/scope/ { print $9 }'`.strip
                           else
                             '0.0.0.0'
                           end
    Capybara.server_port = '43447'
    Capybara.app_host    = "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}"
  end

  config.after :each, type: :system, js: true do
    page.driver.browser.manage.logs.get(:browser).each do |log|
      case log.message
        when /This page includes a password or credit card input in a non-secure context/
          # Ignore this warning in tests
          next
        else
          message = "[#{log.level}] #{log.message}"
          raise message
      end
    end
  end
end
