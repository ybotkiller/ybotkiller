# # Specification for monad operations

/** ^
 * Copyright (c) 2013 Quildreen Motta
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

spec = (require 'hifive')!
{for-all, data: {Any:BigAny, Array:BigArray, Bool, Int}, sized} = require 'claire'
{ok, throws} = require 'assert'

_  = require '../../lib'
deep-eq = require 'deep-equal'
{StaticIdentity:SId, Identity:Id} = require './identity'

Any  = sized (-> 10), BigAny
List = (a) -> sized (-> 10), BigArray(a)

id = (a) -> a

isnt3 = (a, b, c) -> a !== b and b !== c

module.exports = spec 'Monadic Ops' (o, spec) ->

  o 'concat(a, b) <=> a.concat(b)' do
     for-all(List(Any), List(Any)).satisfy (a, b) ->
       _.concat(new Id(a))(new Id(b)).is-equal new Id(a ++ b)
     .as-test!


  o 'empty(a) <=> a.empty()' do
     for-all(Any).satisfy (a) ->
       _.empty(new Id(a)).is-equal SId.empty() and \
       _.empty(new SId(a)).is-equal SId.empty()
     .as-test!

  o 'map(f, a) <=> a.map(f)' do
     for-all(Any).satisfy (a) ->
       _.map(-> [it, it])(new Id(a)).is-equal new Id([a, a])
     .as-test!

  o 'of(a, f) <=> f.of(a)' do
     for-all(Any).satisfy (a) ->
       _.of(a)(new Id(a)).is-equal new Id(a) and \
       _.of(a)(SId).is-equal new SId(a)
     .as-test!

  o 'ap(a, b) <=> a.ap(b)' do
     for-all(Any).satisfy (a) ->
       _.ap(new Id(-> [it, it]))(new Id(a)).is-equal new Id([a, a])
     .as-test!

  o 'chain(f, a) <=> a.chain(f)' do
     for-all(Any).satisfy (a) ->
       _.chain(-> new Id([it, it]))(new Id(a)).is-equal new Id([a, a])
     .as-test!

  o 'sequence(m, ms) should chain monads in ms and collect results.' do
     for-all(Any, Any, Any).satisfy (a, b, c) ->
       _.sequence(SId, [new Id(a), new Id(b), new Id(c)]).is-equal new Id([a,b,c])
     .as-test!

  o 'sequence(m, ms) should run actions in sequence.' do
     for-all(Int, Int, Int).satisfy (a, b, c) ->
       xs = []
       f  = (x) -> { chain: (f) -> xs.push(x); return f(x) }
       (_.sequence(SId, [f a; f b; f c]).isEqual new Id([a, b, c])) \
       && (xs `deep-eq` [a, b, c])
     .as-test!

  o 'map-m(m, f) <=> sequence m . map f' do
     for-all(Any, Any, Any).satisfy (a, b, c) ->
       _.map-m(SId, SId.of, [a, b, c]).is-equal new Id([a, b, c])
     .as-test!

  o 'compose(f, g, a) <=> (f a) >>= g' do
     for-all(Any, Any).given (!==) .satisfy (a, b) ->
       _.compose(-> new Id([it]))(-> new Id(it ++ [b]))(a)
        .is-equal new Id([a, b])
     .as-test!

  o 'compose-right(g, f, a) <=> compose(f, g, a)' do
     for-all(Any, Any).given (!==) .satisfy (a, b) ->
       _.right-compose(-> new Id(it ++ [b]))(-> new Id([it]))(a)
        .is-equal new Id([a, b])
     .as-test!
     
  o 'join should remove one level of a nested monad' do
     for-all(Any).satisfy (a) ->
       _.join(new Id(new Id(a))).is-equal new Id(a)
     .as-test!

  o 'filterM of an empty array should yield m []' do
    for-all(Bool).satisfy (a) ->
      _.filterM(SId, (-> new Id(a)), []).is-equal new Id([])
    .as-test!

  o 'filterM of an array xs for p should only keep items for which p returns m True' do
    for-all(Bool, List(Any)).satisfy (a, xs) ->
      _.filterM(SId, (-> new Id(a)), xs).is-equal new Id(xs.filter (-> a))
    .as-test!

  o 'lift-m2 should promote a regular binary function to a fn over monads' do
     for-all(Any, Any).satisfy (a, b) ->
       _.lift-m2((a, b) -> [a, b])(new Id(a))(new Id(b))
        .is-equal new Id([a, b])
     .as-test!

  o 'lift-mN should promote a N-ary function to a fn over monads' do
     for-all(List(Any)).given (.length > 1) .satisfy (as) ->
       _.lift-MN((...bs) -> bs.slice!reverse!)(as.map -> new Id(it))
        .is-equal new Id(as.slice!reverse!)
     .as-test!

  o 'lift-mN should throw an error for lists of length 0' do
     throws (-> lift-mn id, [])
