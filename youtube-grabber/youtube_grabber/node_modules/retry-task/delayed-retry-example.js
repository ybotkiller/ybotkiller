const fetch = require('isomorphic-fetch')
const Task = require('data.task')
const { delayedRetry } = require('./index')

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
