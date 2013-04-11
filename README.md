## Whatte

What is whatte? A gaffer test, that's what it is.

See [chef-gaffer](https://github.com/sharkerz/chef-gaffer) if you want to deploy [gaffer](http://gaffer.readthedocs.org/) with [Chef](http://www.opscode.com/chef/).

But yeah, my gaffer cookbook is also less than an alpha version, and it does some hacks until gaffer 0.5 is out.

Python 2.7+ is needed.

### Webapps

They are two tests, one is a flask app (run by gunicorn), and the other is a tornado app.

### Dashboard

It uses [Dashing](http://shopify.github.io/dashing/) and [Node.js](http://nodejs.org/), listening on 0.0.0.0:3030.
