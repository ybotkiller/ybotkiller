bin        = $(shell npm bin)
lsc        = $(bin)/lsc
browserify = $(bin)/browserify
jsdoc      = $(bin)/jsdoc
uglify     = $(bin)/uglifyjs
VERSION    = $(shell node -e 'console.log(require("./package.json").version)')

dist:
	mkdir -p dist

dist/control.monads.umd.js: dist
	$(browserify) lib/index.js --standalone Monads > $@

dist/control.monads.umd.min.js: dist/control.monads.umd.js
	$(uglify) --mangle - < $^ > $@

# ----------------------------------------------------------------------
bundle: dist/control.monads.umd.js

minify: dist/control.monads.umd.min.js

documentation:
	$(jsdoc) --configure jsdoc.conf.json
	ABSPATH=$(shell cd "$(dirname "$0")"; pwd) $(MAKE) clean-docs

clean-docs:
	perl -pi -e "s?$$ABSPATH/??g" ./docs/*.html

clean:
	rm -rf dist build

test:
	$(lsc) test/tap.ls

package: documentation bundle minify
	mkdir -p dist/control.monads-$(VERSION)
	cp -r docs dist/control.monads-$(VERSION)
	cp -r lib dist/control.monads-$(VERSION)
	cp dist/*.js dist/control.monads-$(VERSION)
	cp package.json dist/control.monads-$(VERSION)
	cp README.md dist/control.monads-$(VERSION)
	cp LICENCE dist/control.monads-$(VERSION)
	cd dist && tar -czf control.monads-$(VERSION).tar.gz control.monads-$(VERSION)

publish: clean
	npm install
	npm publish

bump:
	node tools/bump-version.js $$VERSION_BUMP

bump-feature:
	VERSION_BUMP=FEATURE $(MAKE) bump

bump-major:
	VERSION_BUMP=MAJOR $(MAKE) bump


.PHONY: test
