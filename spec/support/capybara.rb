# frozen_string_literal: true

RSpec.configure do |config|
  headless = ENV.fetch('HEADLESS', true) != 'false'

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before :each, type: :system, js: true do
    options = headless ? {} : { url: "http://host.docker.internal:9515", browser: :remote }

    driven_by :selenium, using: :chrome, screen_size: [1440, 900], options: options do |driver|
      driver.add_argument('--headless') if headless
      driver.add_argument('--no-sandbox')
      driver.add_argument('--disable-dev-shm-usage')
      driver.add_argument('--disable-gpu')
    end

    Capybara.raise_server_errors = false

    Capybara.server = :puma, { Silent: true }

    # Find Docker IP address
    if !headless
      Capybara.server_host = "0.0.0.0"
    end

    Capybara.server_port = '43447'

    Capybara.app_host =
      "http://#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}"
  end
end
