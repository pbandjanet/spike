# SPIKE

Installation
1. Install npm packages (if you haven't already) with `npm install`.
2. Install postgresql (e.g. from <a href=http://postgresapp.com/>postgres.app</a>)

Fetch remote db info (this will have to change if we ever have a lot of data)
1. `export DATABASE_URL=gmodb`
2. `psql -c "DROP DATABASE gmodb;"` (drop `gmodb` so that it can be overwritten by `heroku pg:pull`)
3. `heroku pg:pull postgresql-transparent-88316 gmodb`

Run locally:
1. run `make`
2. go to <a href=http://localhost:5000>localhost:5000</a>

Push to Heroku
1. `git push heroku master`

Start Heroku server
1. `heroku ps:scale web=1`

Take down the Heroku server
1. `heroku ps:scale web=0`
