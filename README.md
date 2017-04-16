# SPIKE

1. Install npm packages (if you haven't already) with `npm install`.
2. Then run `make` and go to <a href=http://localhost:5000>localhost:5000</a>


Push to Heroku
1. `git push heroku master`

Start Heroku server
1. `heroku ps:scale web=1`

Take down the Heroku server
1. `heroku ps:scale web=0`
