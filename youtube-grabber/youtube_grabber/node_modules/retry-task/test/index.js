var Task = require('data.task')
var td = require('testdouble')
var chai = require('chai')
var expect = chai.expect

var RetryTask = require('../index')

describe('retry-task module', function () {
  it('exports an object with two functions', function () {
    expect(RetryTask).to.have.property('retry').that.is.a('function')
    expect(RetryTask).to.have.property('delayedRetry').that.is.a('function')
  })
})

describe('retry function', function () {
  var retry = RetryTask.retry

  it('returns immediately if the Task succeeds', function (done) {
    var result = 'SUCCESS'
    var taskFunc = td.function()
    td.when(taskFunc(), {times: 1}).thenReturn(Task.of(result))

    retry(3)(taskFunc)
      .fork(function (e) { done('Got an error: ' + e) },
            function (r) {
              expect(r).to.equal(result)
              done()
            })
  })

  it('retries until the Task succeeds', function (done) {
    var result = 'SUCCESS'
    var taskFunc = td.function()
    td.when(taskFunc(), {times: 3}).thenReturn(
      Task.rejected('nope'),
      Task.rejected('nope'),
      Task.of(result))

    retry(3)(taskFunc)
      .fork(function (e) { done('Got an error: ' + e) },
            function (r) {
              expect(r).to.equal(result)
              done()
            })
  })

  it('rejects if the Task never succeeds', function (done) {
    var result = 'SUCCESS'
    var error = 'ERROR'
    var taskFunc = td.function()
    td.when(taskFunc(), {times: 4})
      .thenReturn(
        Task.rejected('nope'),
        Task.rejected('nope'),
        Task.rejected('nope'),
        Task.rejected(error))

    retry(3)(taskFunc)
      .fork(function (e) {
              expect(e).to.equal(error)
              done()
            },
            function () { done('Task should not have completed') })
  })
})

describe('delayedRetry function', function () {
  var delayedRetry = RetryTask.delayedRetry
  this.timeout(10000)

  it('returns immediately if the Task succeeds', function (done) {
    var result = 'SUCCESS'
    var taskFunc = td.function()
    td.when(taskFunc(), {times: 1}).thenReturn(Task.of(result))

    var retryTask = delayedRetry(3, 30000)
    var start = Date.now()
    retryTask(taskFunc)
      .fork(function (e) { done('Got an error: ' + e) },
            function (r) {
              expect(r).to.equal(result)
              expect(Date.now()).to.be.closeTo(start, 20)
              done()
            })
  })

  it('works when delay is a number', function (done) {
    var delay = 200
    var result = 'SUCCESS'
    var taskFunc = td.function()
    td.when(taskFunc(), {times: 3})
      .thenReturn(
        Task.rejected('nope'),
        Task.rejected('nope'),
        Task.of(result))

    var retryTask = delayedRetry(3, delay)
    var start = Date.now()
    retryTask(taskFunc)
      .fork(function (e) { done('Got an error: ' + e) },
            function (r) {
              expect(r).to.equal(result)
              var expectedDelay = start + (2 * delay)
              expect(Date.now()).to.be.closeTo(expectedDelay, 20)
              done()
            })
  })

  it('works when delay is a function', function (done) {
    var result = 'SUCCESS'
    var delays = [200, 400]
    var delaysTotal = delays.reduce(function (a, x) { return a + x }, 0)
    var delayFunc = td.function()
    td.when(delayFunc(1), {times: 1})
      .thenReturn(delays[0])
    td.when(delayFunc(2), {times: 1})
      .thenReturn(delays[1])


    var taskFunc = td.function()
    td.when(taskFunc(), {times: 3})
      .thenReturn(
        Task.rejected('nope'),
        Task.rejected('nope'),
        Task.of(result))

    var retryTask = delayedRetry(3, delayFunc)
    var start = Date.now()
    retryTask(taskFunc)
      .fork(function (e) { done('Got an error: ' + e) },
            function (r) {
              expect(r).to.equal(result)
              var expectedDelay = start + delaysTotal
              expect(Date.now()).to.be.closeTo(expectedDelay, 20)
              done()
            })
  })

  it('rejects if the Task never succeeds', function (done) {
    var result = 'SUCCESS'
    var error = 'ERROR'
    var delay = 200
    var taskFunc = td.function()
    td.when(taskFunc(), {times: 4})
      .thenReturn(
        Task.rejected('nope'),
        Task.rejected('nope'),
        Task.rejected('nope'),
        Task.rejected(error))

    var start = Date.now()
    delayedRetry(3, delay)(taskFunc)
      .fork(function (e) {
              expect(e).to.equal(error)
              var expectedDelay = start + 3 * delay
              expect(Date.now()).to.be.closeTo(expectedDelay, 20)
              done()
            },
            function () { done('Task should not have completed') })
  })
})
