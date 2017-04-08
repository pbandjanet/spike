run: browserify
	coffee server.coffee

browserify:
	browserify -t coffeeify sender/browsersend.coffee > browsersend.js
