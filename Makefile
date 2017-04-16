run: browserify
	coffee server.coffee

browserify:
	mkdir -p views/js/
	./node_modules/.bin/browserify -r ./sender/browsersend.coffee:browser-send -t coffeeify -t babelify > views/js/browsersend.js
