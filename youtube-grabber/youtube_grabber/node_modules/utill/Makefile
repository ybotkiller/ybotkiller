test-travis:
	@$(MAKE) lintv
	@echo TRAVIS_JOB_ID $(TRAVIS_JOB_ID)
	@$(MAKE) test-coveralls

lint:
	./node_modules/.bin/jshint --reporter node_modules/jshint-stylish/stylish.js ./lib ./test ./index.js
  
test-coverage:
	./node_modules/.bin/istanbul cover ./node_modules/mocha/bin/_mocha -- -R spec

test-coveralls:
	./node_modules/.bin/istanbul cover ./node_modules/mocha/bin/_mocha --report lcovonly -- -R spec && cat ./coverage/lcov.info | ./node_modules/coveralls/bin/coveralls.js && rm -rf ./coverage

generate-istanbul-report:
	./node_modules/.bin/istanbul report html

test:
	@$(MAKE) lint
	@$(MAKE) test-coverage
	@$(MAKE) generate-istanbul-report

.PHONY: test 