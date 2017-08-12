const fetch = require('isomorphic-fetch')
const Task = require('data.task')
const { retry } = require('./index')

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
