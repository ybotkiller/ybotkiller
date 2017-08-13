var Task = require('data.task')
var lambda = require('core.lambda')
var curry = lambda.curry

var delayTask = function (delay) {
  return new Task(function (rej, res) {
    setTimeout(res, delay)
  })
}

var delayedRetry = function (retries, delay, fn) {
  var getDelay = (typeof delay === 'function')
    ? delay
    : function () { return delay }

  var doTry = function (attemptNo) {
    return fn()
      .orElse(function (e) {
        return (attemptNo < retries)
          ? delayTask(getDelay(attemptNo + 1))
              .chain(function () { return doTry(attemptNo + 1) })
          : Task.rejected(e)
        })
  }

  return doTry(0)
}

var retry = function (retries, fn) {
  return delayedRetry(retries, 0, fn)
}

module.exports = {
  retry: curry(2, retry),
  delayedRetry: curry(3, delayedRetry)
}
