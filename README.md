# SPIKE

Installation
1. Install npm packages (if you haven't already) with `npm install`.
2. Install postgresql (e.g. from <a href=http://postgresapp.com/>postgres.app</a>)
3. Make sure you have copies of `mailgunkey.json` and `emailerdata.json` in the same director as `emailer.coffee`.

Fetch remote db info (this will have to change if we ever have a lot of data)
1. `psql -c "DROP DATABASE gmodb;"` (drop `gmodb` so that it can be overwritten by `heroku pg:pull`)
2. `heroku pg:pull postgresql-transparent-88316 gmodb`

Run locally:
1. run `make`
2. go to <a href=http://localhost:5000>localhost:5000</a>

Get a psql session on the heroku postgres server:
1. `heroku pg:psql`

Push to Heroku
1. `git push heroku master`

Start Heroku server
1. `heroku ps:scale web=1`

Take down the Heroku server
1. `heroku ps:scale web=0`
