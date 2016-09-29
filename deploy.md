# Deploying the Dashboard

## Environment

You will need a Linux environment with [Ruby](https://www.ruby-lang.org/en/) installed.  To see which version of Ruby is currently installed, run:

```
ruby --version
```

To see which version of Ruby the Dashboard currently needs:

```
cat .ruby-version
```

If your environment has a different version of Ruby than what the Dashboard expects, you can either change the global version or install [rvm](http://rvm.io/) to manage multiple Ruby versions.  Once rvm is installed, you can install the proper version of Ruby by running:

```
rvm install `cat .ruby-version`
```

> Note that rvm might need root permissions, depending on your system, so it might be necessary to run this with `su`!

The environment will also need [PostgreSQL](https://www.postgresql.org/).  This small, lightweight database is used by the Dashboard for authentication and authorization.  Note that development bindings for Postgres are also needed, which requires an additional install depending on your OS:

```
# RedHat
yum install postgresql-devel
```

## The application

The application depends on a handful of Ruby libraries.  These are specified in the Gemfile.  The Gemfile provides a quick way to install all of the libraries at once using `bundle` instead of having to do each one manually.  To install the application library dependencies, run:

```
# Make sure bundle is installed.
gem install bundle

# Install from the Gemfile
bundle install
```

> Note that the `gem install` command might require root permissions, depending on how your environment is configured.

## Deploy scripting

Without a PaaS for deployment, the best option for scripting deploys is
a tool called [Capistrano](http://capistranorb.com/). Capistrano solves
the problems of maintaining shared resources between deploys such as
database configuration and logs.

Using this tool or another, database configuration is managed via a file
that is copied in after the code is deployed: `config/database.yml`.
The one checked into source control is setup for development/test
environments, and can serve as an example for the one needed for
production. See [Rails documentation](http://edgeguides.rubyonrails.org/configuring.html#configuring-a-database) for more details on what this file contains and how it can be modified.

## Preparing the database

This application has a very small need for data. It is mostly connecting
to the API to get reporting data. It stores a bit of additional
information on daily capacity and a user authentication system. We are
using a small shared postgres database for staging. For the forseeable
future, the data will be less than 250MB, and have very small memory
needs. We don't have the details or our postgres configuration, but
expect that the most basic postgres setup will be sufficient.

There are Ruby scripts provided to create the database using `rake`.  To get the database ready, run:

```
# Make sure rake is installed
gem install rake

# Create the database and run migrations
rake db:create:all
rake db:migrate 
```

> Note that the `gem install` command might require root permissions, depending on how your environment is configured.

## Email configuration

The Dashboard uses email to verify new accounts and to reset passwords.  In order to do this, it must be configured to know what email server to use.  This is configured in the file `config/environments/production.rb`, in the `config.action_mailer.smtp_settings` key:

```
config.action_mailer.smtp_settings = {
    address: ENV['SMTP_ADDRESS'],
    port: ENV['SMTP_PORT'],
    domain: ENV['SMTP_DOMAIN'] || "18f.gsa.gov",
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: 'login',
    enable_starttls_auto: true
  }
```

This configures Action Mailer.  For a full explanation of this configuration, check the [Action Mailer configuration page](http://guides.rubyonrails.org/action_mailer_basics.html#action-mailer-configuration).

Note that by default, this configuration will use environment variables for the SMTP address, port, domain (for HELO), username, and password.  If the other information in the configuration is appropriate for your environment, there is no need to change the `config/environment/production.rb` file.

## Environment variables

There are a few required environment variables:

```
export RAILS_ENV='production'
export RACK_ENV='production'
export API_URL='https://url-to-api.gov/'
export AUTH_HMAC_SECRET='some-secret-string'
export SECRET_KEY_BASE='some-other-secret-string'

export SMTP_ADDRESS='smtp.mail.tld.gov'
export SMTP_DOMAIN='smtp.mail.tld.gov'
export SMTP_USERNAME='smtp-username'
export SMTP_PASSWORD='smtp-password'
```

The `API_URL` environment variable is the URL to the API server.  It is a regular URL and can include a port and so on.

The `AUTH_HMAC_SECRET` environment variable is used to encrypt authentication calls between the Dashboard and API, and must be set to the same value on both.  It is a cryptographic key so should be reasonably secure.  A reasonable choice would be to concatenate together a couple of passwords from https://www.grc.com/passwords.htm.

In addition Rails uses a secret key base to authenticate requests. In order
for the server to work, you will need to set this value to a similar
large value secret.

Rails comes with a handy script for generating theses keys:

  rake secret

## Seeding the application with data

### Creating an admin user

As mentioned, the application has a user management system built in,
however the first user has to be created as an admin for this to work.

We have built a script to create a user with Olympia's email. The
password will be made up and she will need to follow a password reset
link provided in email to reset her email and login.

Since there is an email dependency in this flow, please verify that the
email server is setup correctly before running the task:

    rake dashboard:create_first_admin

### Importing data from a CSV

The dashboard data reports via 7 and 30 day averages, and when the
application starts it has no days of data. To fix this Olypia will be
providing a CSV file of the format provided at `./sample-daily-stats.csv`
for import.

We have built a script for importing data from such a file.

* Place the file somewhere navigable from the root directory of the app
* Run: `rake dashboard:import_csv ../path-to-my-file/example.csv`

## Start the Dashboard

To start the Dashboard, you'll need to launch rails and indicate what network interface to bind to.  To do this, run:

```
# Bind to every interface
bin/rails server --binding=0.0.0.0
```

By default, this will listen on port 3000.  To change the port, use the `-p` argument:

```
bin/rails server --binding=0.0.0.0 -p 3001
```
