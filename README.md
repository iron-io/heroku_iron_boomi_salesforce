First you need a token and project_id from your Iron.io account. Login at http://www.iron.io
to get it.

To run in development:

- Copy the config_sample.yml file and fill in the appropriate values.
- Run _rackup_ at the command line.

To run on heroku:

- heroku addons:add iron_worker
- heroku addons:add iron_mq
- git push heroku master

Since there are several parties involved you will have to share your Iron.io project with another party or they will have
to share their Iron.io project with you. If someone else shares it with you, you will have to set the Heroku environment
variables explicitly:

    heroku config:add IRON_TOKEN=TOKEN
    heroku config:add IRON_PROJECT_ID=PROJECT_ID

