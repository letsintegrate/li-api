# Let's integrate! API

<img src="logo.png" align="right" alt="Let's integrate!" />

[![Code Climate](https://codeclimate.com/github/letsintegrate/li-api/badges/gpa.svg)](https://codeclimate.com/github/letsintegrate/li-api)
[![Code Climate](https://codeclimate.com/github/letsintegrate/li-api/badges/gpa.svg)](https://codeclimate.com/github/letsintegrate/li-api)

This is the API of the Let's integrate! project. To know what it's about, please
visit our website at https://letsintegrate.de/.

## Using the API

There is currently no detailed documentation on how to use the API but we use
the [rspec-apib](https://github.com/spieker/rspec-apib) gem to generate an
[API Blueprint](https://apiblueprint.org/) documentation and then upload it
to [Apiary](https://apiary.io/). The generated documentation can be found here:

http://docs.letsintegrateapi.apiary.io/

## Development

The Let's integrate! API is based on [Ruby on Rails 4](http://rubyonrails.org/).
For setting up the development environment, [Docker](https://www.docker.com/)
with [Docker Compose](https://docs.docker.com/compose/) and
[direnv](http://direnv.net/) is used. The development workflow is organized by
[GitHub pull requests](https://help.github.com/articles/using-pull-requests/)
and the
[GitFlow](http://jeffkreeftmeijer.com/2010/why-arent-you-using-git-flow/)
development workflow. Please make yourself familiar with the things mentioned
above before actually starting to code.

### Preparing Docker Compose

Before you are able to run any tests or rails tasks, you need to create the
Docker images using Docker Compose.

```
docker-compose build
```

### Creating the Database

To run the tests, the test database has to be created and migrated first. To do
so, you need to run `rails db:create` and `rails db:migrate` within the Docker
container.

```
docker-compose run web rake db:create db:migrate RAILS_ENV=test
```

### Testing

After building the Docker images and creating the database you are good to go to
run the tests and start developing at Let's integrate! You can run the tests
either manually using the `rspec` command or permanently by using `guard`.

RSpec:

```
docker-compose run web rspec
```

Guard:

```
docker-compose run web guard
```

### Contribute

1. Fork the repository on GitHub
2. Clone it: `git clone git@github.com:letsintegrate/li-api.git`
3. Init git flow `git flow init`
4. Create a new branch for your feature using GitFlow:
   `git flow feature start my-awesome-feature` (Requires the
   [GitFlow](https://github.com/nvie/gitflow/wiki/Installation) addon to be
   installed)
5. Make your changes, test them using [RSpec](http://rspec.info/) and commit
   them
6. Push the changes to GitHub: `git push -u origin feature/my-awesome-feature`
7. Create a Pull request

### Updating global_phone database

```
gem install global_phone_dbgen
/bundle/bin/global_phone_dbgen 'https://raw.githubusercontent.com/googlei18n/libphonenumber/master/resources/PhoneNumberMetadata.xml' > db/global_phone.json
```

## License

The MIT License (MIT)
Copyright (c) 2016 Let's integrate!

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Supported by

<a href="http://github.com/">
  <img src="/github.png?cefc20232703e5e3c24efd5f50d75e26" alt="GitHub" height="40px">
</a>
<a href="http://browserstack.com/">
  <img src="/browserstack.png?c25aa4c83d0233abc8c1905a18f26c1a" alt="BrowserStack" height="40px">
</a>
