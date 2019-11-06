<p align="center">
  <img src="https://default.salsalabs.org/api/organization/e2390606-bfe8-4802-974b-cb2bb603a4fb/logo/data" alt="Moms and Dads Logo" background>
</p>

<p align="center">
  <a href="https://codeclimate.com/github/OfficeMomsandDads/scheduler/maintainability"><img src="https://api.codeclimate.com/v1/badges/aaf7efce352e6a023791/maintainability" alt="Maintainability"></a>
  <a href="https://codeclimate.com/github/OfficeMomsandDads/scheduler/test_coverage"><img src="https://api.codeclimate.com/v1/badges/aaf7efce352e6a023791/test_coverage" alt="Test Coverage"></a>
  <a href="https://gitter.im/office-moms-and-dads/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge">
  <img src="https://badges.gitter.im/office-moms-and-dads/community.svg" alt="Gitter Chat Link"></a>
</p>

<br>

---

# Scheduler

## Overview

### Who are we?

Office Moms & Dads, a nonprofit organization, is a community of qualified volunteers partnering with child welfare offices to provide a nurturing environment for children entering foster care.

Office Moms & Dads’ 5-year vision is to establish and sustain sites throughout Washington and Idaho where children entering care transition with minimal trauma into their foster care placement.

## What does the scheduler do?

It is a Ruby/Rails based app that allows the coordination of scheduling between various workers and volunteers supporting children entering the foster care system. Specifically, it is designed to alert volunteers when there is need of a kind person to sit with children during a scary time, often on short notice. For more information about the organization, please visit [Office Moms and Dads](http://www.officemomsanddads.com).

<hr />

## Table of Contents

- [Overview](#overview)
  - [Who are we](#who-are-we?)
  - [What does the scheduler do](#what-does-it-do)
- [Development Environment Setup](#development-environment-setup)
  - [Helpful Docker Commands](#helpful-docker-commands)
  - [Rails Commands in a Docker World](#rails-commands-in-a-docker-world)
  - [System Tests](#system-tests)
- [Contributing to the Effort](#contributing-to-the-effort)
  - [Guide for Contributing to the Project](#ways-to-contribute-to-the-project)
  - [Reporting Issues](#reporting-issues)
  - [Contacting Us](#contacting-us)
- [Technologies Used](#technologies-used)
- [License](#license)
  <hr />

## Development Environment Setup

1. [Download Docker CE for Mac](https://store.docker.com/editions/community/docker-ce-desktop-mac)
   > Note: remove boot2docker or other Docker implementations if any were previously installed
2. Copy the `env.example` file to `.env`
   `cp env.example .env`

   > Note: There exists a .env file in 1Password intended for development.
   > Note: On Mac, make sure to append `:docker-compose.mac.yml` to `COMPOSE_FILE` to take advantage of cached volumes

3. Run `docker-compose up`
4. Open a browser to localhost:3000 to verify that the app is up.

### Helpful Docker Commands

- `docker-compose up` Starts fresh containers `-d` starts it in daemon mode
- `docker-compose down` Stops and removes containers(all data too)
- `docker-compose stop` Stops running containers but persists data
- `docker-compose start` Starts containers with persisted data
- `docker system prune` Cleans up unused containers, networks, and images `-a` removes all
  > Note: it is recommended to run the clean up commands weekly
- `docker ps` Lists all running containers
- `docker-compose run app bash` Starts a bash session on app, bringing up only dependent services.
- `docker exec -it ID_FROM_DOCKER_PS bash`. Connects another bash session to a running container.
- `docker attach ID_FROM_DOCKER_PS` Attach is useful for pry debugging in a running container
  > Note: To detach use `ctrl-p + ctrl-q`

### Rails Commands in a Docker World

Now that the app is running in Docker we will run all Rails and Rake commands in the container.

Here are a few examples:

> Note: this is expecting the containers are up

- `docker-compose exec app bundle exec rake db:migrate`
- `docker-compose exec app bundle exec rails c`

The pattern is docker-compose exec (container_name) rails or rake command.
This pattern works for non-Rails commands also.

- `docker-compose exec app bash` will open the terminal on the container

### System Tests

System tests open the browser and make assertions against the content of the
page or verify expected behavior. These tests can be run in headless mode (the
default), which means that they are executed in a virtual browser. If you would
like them to be run in an actual, viewable browser, you will need to disable
headless mode by setting the HEADLESS environment variable to 'false' and ensure
you have the [ChromeDriver WebDriver](https://sites.google.com/a/chromium.org/chromedriver/downloads)
downloaded and installed on your host machine.

E.g. `HEADLESS=false bundle exec rspec spec/system/mytest_spec.rb`

If you are running in non-headless mode, you'll need to be sure you have the ChromeDriver running and able to accept connections from the IP the server is running on. This can be done by running ChromeDriver in a separate tab/console via:

`./chromedriver --whitelisted-ips`

<hr />

## Contributing to the Effort

First, we would like to thank you for having an interest in helping with this project! There are several things you can do:

- Help with issues
  - Close open issues by fixing them and making a pull request
  - Reproduce an issue for you or others to fix
- Refactor code
  - Before you put in the work, please open a new issue so we can discuss it.

### Contribution Guide

Fork this repository, clone your forked repo, and then [setup your environment](#development-environment-setup). Then make a branch, with a descriptive name, for the specific issue that you want to tackle.

- Make changes to fix the relevant issue, making your commit messages conform to our [commit message guidelines](#commit-message-guidelines) listed below.

- Please write tests and make sure that you have full coverage for all lines for your code.

  - After running rspec, the coverage will be updated and can be viewed.

  - To check the coverage of your tests, open coverage/index.html in a browser. You may need to drag the file from your editor to a new browser tab.

- After you have made changes and have passing specs with full coverage, please submit a pull request to merge your created branch with master.

#### Commit message guidelines

1. Please make the first line short and descriptive.

2. Please insert a blank line between the subject and any additional message content.

### Reporting Issues

If you encounter a bug or odd behavior that appears unintentional, please Openq an issue ticket and clearly describe the problem, reproducing it exactly if possible.

### Contacting the maintainers

For all other questions and concerns related to this project, please open an issue with a short but clear description. Responses will be as quick as possible, so Thank You in advance for your patience.

---

## Technologies Used

- Docker
- Ruby-On-Rails
- React
- Twilio

---

## Support and Contact details

Interested in finding out more about what we do, or how you can support our mission? Please visit our [website](https://officemomsanddads.com).

If after reading about us, you still have questions, you can directly [contact us](https://officemomsanddads.com/contact-us/) through our website.

---

## License

[![license](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE.md)

This software is licensed under the [MIT license](LICENSE.md).
