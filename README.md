# Office Moms and Dads Scheduler

* [Development Environment Setup](#development-environment-setup)
* [Helpful Docker Commands](#helpful-docker-commands)
* [Rails Commands in a Docker World](#rails-commands-in-a-docker-world)
* [Import Postgres Dump](#import-postgres-dump)

### Development Environment Setup

1. [Download Docker CE for Mac](https://store.docker.com/editions/community/docker-ce-desktop-mac)
> Note: remove boot2docker or other Docker implementations if any were previously installed

2. Move Docker to your Applications and open the App
3. Change `config/database.yml.example` to `config/database.yml` and configure it for your environment
4. Open Terminal navigate to the root of the app and run `docker-compose build`
5. Run `docker-compose up`
6. Open a browser to localhost:3000 verify the app is up.

### Helpful Docker Commands
* `docker-compose up` Starts fresh containers `-d` starts it in daemon mode
* `docker-compose down` Stops and removes containers(all data too)
* `docker-compose stop` Stops running containers but persists data
* `docker-compose start` Starts containers with persisted data
* `docker system prune` Cleans up unused containers, networks, and images `-a` removes all
> Note: it is recommended to run the clean up commands weekly
* `docker ps` Lists all running containers
* `docker-compose run app bash` Starts a bash session on app, bringing up only dependent services.
* `docker exec -it ID_FROM_DOCKER_PS bash`. Connects another bash session to a running container.
* `docker attach ID_FROM_DOCKER_PS` Attach is useful for pry debugging in a running container
> Note: To dettach use `ctrl-p + ctrl-q`

### Rails Commands in a Docker World
Now that the app is running in Docker we will run all Rails and Rake commands in the container.

Here are a few examples:
> Note: this is expecting the containers are up

* `docker-compose exec app bundle exec rake db:migrate`
* `docker-compose exec app bundle exec rails c`

The pattern is docker-compose exec (container_name) rails or rake command.
This pattern works for non-Rails commands also.

* `docker-compose exec app bash` will open the terminal on the container