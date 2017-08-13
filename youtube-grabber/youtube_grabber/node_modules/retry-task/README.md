# retry-task

Retry a Task a given number of times until it succeeds.

The module is built for use with [Folktale's Task monad](http://docs.folktalejs.org/en/latest/api/data/task/) ([data.task](https://github.com/folktale/data.task)).

[![Build Status](https://travis-ci.org/philbot9/retry-task.svg?branch=master)](https://travis-ci.org/philbot9/retry-task)

## Usage

The module exports an object with two functions.

`retry(retries, fn)`

The function accepts a number of `retries` indicating the maximum number of retries and `fn`, a function that returns a task. Note that the number of `retries` excludes the initial trial before failure. I.e. if `fn` always fails and `retries = 2` then `fn` will be called **three times in total**.


`delayedRetry(retries, delay, fn)`

The function accepts a number of `retries` indicating the maximum number of retries (see above). The `delay` parameter can be either a number, indicating the time to wait between retries in **milliseconds**, or a function that returns such a number. A `delay` function is called before each retry with the next attempt number (`1`, `2`, `3`, ...) as the first parameter. The `fn` parameter is a function that returns a task.

## Miscellaneous

Both functions are **curried**.

## Examples

### retry

``` javascript
const fetch = require('isomorphic-fetch')
const Task = require('data.task')
const { retry } = require('retry-task')

const fork = t =>
  t.fork(console.error, console.log)

// Basic
let calls = 0
const failTwice = () =>
  new Task((rej, res) =>
    calls++ >= 2 ? res('All good!') : rej('nope'))

const basic1 = retry(2, failTwice)
fork(basic1)

const alwaysFail = () =>
  new Task(rej => rej('ALWAYS BLUE!'))
const basic2 = retry(2, alwaysFail)

fork(basic2)

// Fetching URLs with retries
const fetchUrl = url =>
  new Task((rej, res) =>
    fetch(url)
      .then(r => res(`[${r.status}] ${r.statusText}`))
      .catch(rej))

const npm = retry(3, () => fetchUrl('http://www.npmjs.com/'))
fork(npm)

// since the function is curried we can also do this
const withRetries = retry(3)
const npm2 = withRetries(() => fetchUrl('http://www.npmjs.com/'))
const google = withRetries(() => fetchUrl('http://www.google.com/'))
fork(npm2)
fork(google)
```

### delayedRetry

``` javascript
const fetch = require('isomorphic-fetch')
const Task = require('data.task')
const { delayedRetry } = require('retry-task')

const fork = t =>
  t.fork(console.error, console.log)

// Basic
let calls = 0
const failTwice = () =>
  new Task((rej, res) =>
    calls++ >= 2 ? res('All good!') : rej('nope'))

const basic1 = delayedRetry(2, 1000, failTwice)
fork(basic1)

const alwaysFail = () =>
  new Task(rej => rej('ALWAYS BLUE!'))
const basic2 = delayedRetry(2, 1000, alwaysFail)

fork(basic2)

// Fetching URLs with retries
const fetchUrl = url =>
  new Task((rej, res) =>
    fetch(url)
      .then(r => res(`[${r.status}] ${r.statusText}`))
      .catch(rej))

const npm = delayedRetry(3, 1000, () => fetchUrl('http://www.npmjs.com/'))
fork(npm)

// since the function is curried we can also do this
const withRetries = delayedRetry(3)
const withDelayedRetries = withRetries(1000)
const npm2 = withDelayedRetries(() => fetchUrl('http://www.npmjs.com/'))
const google = withDelayedRetries(() => fetchUrl('http://www.google.com/'))
fork(npm2)
fork(google)

// Custom delay function
const delay = attemptNo =>
  attemptNo * 1000 // attemptNo is always >= 1

const withCustomDelayedRetries = withRetries(delay)
const npm3 = withCustomDelayedRetries(() => fetchUrl('http://www.npmjs.com'))
fork(npm3)
```
