First you need a token and project_id from your Iron.io account. Login at http://www.iron.io
to get it.

To run in development:

- Copy the config_sample.yml file and fill in the appropriate values.
- Run _rackup_ at the command line.

To run on heroku:

- heroku addons:add iron_worker
- heroku addons:add iron_mq
- git push heroku master

