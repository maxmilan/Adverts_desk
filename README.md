#README
[![Build Status](https://travis-ci.org/maxmilan/Adverts_desk.svg?branch=master)](https://travis-ci.org/maxmilan/Adverts_desk)
[![Code Climate](https://codeclimate.com/repos/542f3078e30ba07ca000458b/badges/57c0e0881f882cf72369/gpa.svg)](https://codeclimate.com/repos/542f3078e30ba07ca000458b/feed)
[![Dependency Status](https://gemnasium.com/maxmilan/Adverts_desk.svg)](https://gemnasium.com/maxmilan/Adverts_desk)
[![security](https://hakiri.io/github/maxmilan/Adverts_desk/master.svg)](https://hakiri.io/github/maxmilan/Adverts_desk/master)

This README would normally document whatever steps are necessary to get the
application up and running.

##Ruby version 2.1.3

##Deployment
If you are deploying this application you should follow instruction
```
rake db:migrate
```
This command will role migrations in database. But your database will be empty. If you want to
fill it by default data, you should enter
```
rake db:seed
```
This command will create administrator with **email**: `admin@advert.com` and **password**: `82368236`
and **categories**: `transport, realty`
If you want to fill database by random adverts run
```
rake advert_generators:generate
```
To start **crontab tasks** you should rake the following task
```
rake advert_generators:update_crontab
```

##Testing
How you want to test the application you should run
```
bundle exec rspec
```

##Services
This application using search engine ElasticSearch. To correctly working applicaton
you should enter `./elasticsearch-0.20.6/bin` and start elastic search server running command
```
elasticsearch -f
```

## Actions log
You can find information about all actions in `./log/notifications.log`

## Database configuration
This application uses PostgresQl database. To configure database you should fill
`./config/examples/database.yml` file with your **username** and **password**

## Dropbox connection
We use Dropbox to store advert images. To use the application you should
create new app on Dropbox. The type of app should be **app_folder**.
When the app is created, you should fill the neccessary information about it in `./config/examples/dropbox_config.yml`