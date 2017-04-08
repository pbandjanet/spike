run: browserify
	coffee server.coffee

browserify:
	browserify -r ./sender/browsersend.coffee:browser-send -t coffeeify > views/js/browsersend.js
