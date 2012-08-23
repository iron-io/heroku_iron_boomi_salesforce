First you need a token and project_id from your Iron.io account. Login at http://www.iron.io
to get it or to sign up.

To run in development:

- Copy the config_sample.yml file and fill in the appropriate values.
- Run `rake push_config` to store config
- Run `rackup` at the command line

To run on heroku:



Now type

    heroku config

To get your new project id's and tokens for the Iron products.



    git push heroku master

Since there are several parties involved you will have to share your Iron.io project with another party or they will have
to share their Iron.io project with you. If someone else shares it with you, you will have to set the Heroku environment
variables explicitly:

    heroku config:add IRON_TOKEN=TOKEN
    heroku config:add IRON_PROJECT_ID=PROJECT_ID

