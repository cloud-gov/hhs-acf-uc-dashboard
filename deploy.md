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

The environment will also need [PostgreSQL](https://www.postgresql.org/).  This small, lightweight database is used by the Dashboard for authentication and authorization.  [I assume the meat of application data will come from the API soon]

## The application

The application depends on a handful of Ruby libraries.  These are specified in the Gemfile.  The Gemfile provides a quick way to install all of the libraries at once using `bundle` instead of having to do each one manually.  To install the application library dependencies, run:

```
# Make sure bundle is installed.
gem install bundle

# Install from the Gemfile
bundle install
```

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

## Environment variables

There are a few required environment variables:

```
export RAILS_ENV='production'
export RACK_ENV='production'
export API_URL='https://url-to-api.gov/'
export AUTH_HMAC_SECRET='some-secret-string'
export SECRET_KEY_BASE='some-other-secret-string'
```

The `API_URL` environment variable is the URL to the API server.  It is a regular URL and can include a port and so on.

The `AUTH_HMAC_SECRET` environment variable is used to encrypt authentication calls between the Dashboard and API, and must be set to the same value on both.  It is a cryptographic key so should be reasonably secure.  A reasonable choice would be to concatenate together a couple of passwords from https://www.grc.com/passwords.htm.

In addition Rails uses a secret key base to authenticate requests. In order
for the server to work, you will need to set this value to a similar
large value secret.

Rails comes with a handy script for generating theses keys:

  rake secret


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
