#!/bin/bash

# create test database
rake db:create RAILS_ENV=test &&

# load schema of database
rake db:schema:load RAILS_ENV=test &&

# load test data
rake db:fixtures:load RAILS_ENV=test
