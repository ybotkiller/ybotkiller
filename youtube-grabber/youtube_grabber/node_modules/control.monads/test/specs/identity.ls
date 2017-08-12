# # The Identity container

/** ^
 * Copyright (c) 2013 Quildreen "Sorella" Motta <quildreen@gmail.com>
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

deep-eq = require 'deep-equal'

# This module provides a minimal, fully conforming, implementation of
# the Identity container. It serves both as an example, and as a way to
# test if the equations in the laws actually do what they're supposed
# to.

export class StaticIdentity
  (a) ->
    @value    = a
    @is-empty = false

  # Semigroup
  concat: (b) ->
    | @is-empty  => b
    | b.is-empty => this
    | otherwise  => new Identity (@value ++ b.value)

  # Monoid
  @empty = -> new Identity <<< { is-empty: true }

  # Functor
  map: (f) -> new Identity (f @value)

  # Applicative / Monad
  ap: (b) -> new Identity (@value b.value)

  @of = (a) -> new Identity a

  # Chain / Monad
  chain: (f) -> f @value

  # Eq
  is-equal: (a) ->
    | @is-empty => a.is-empty
    | otherwise => !a.is-empty and (@value `deep-eq` a.value)
  

export class Identity extends StaticIdentity
  of: StaticIdentity.of
  empty: StaticIdentity.empty

delete Identity.of
delete Identity.empty
