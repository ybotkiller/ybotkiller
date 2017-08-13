control.monads
==============

[![Build Status](https://secure.travis-ci.org/folktale/control.monads.png?branch=master)](https://travis-ci.org/folktale/control.monads)
[![NPM version](https://badge.fury.io/js/control.monads.png)](http://badge.fury.io/js/control.monads)
[![Dependencies Status](https://david-dm.org/folktale/control.monads.png)](https://david-dm.org/folktale/control.monads)
[![experimental](http://hughsk.github.io/stability-badges/dist/experimental.svg)](http://github.com/hughsk/stability-badges)


Common monad combinators and sequencing operations.


## Example

```js
( ... )
```


## Installing

The easiest way is to grab it from NPM. If you're running in a Browser
environment, you can use [Browserify][]

    $ npm install control.monads


### Using with CommonJS

If you're not using NPM, [Download the latest release][release], and require
the `control.monads.umd.js` file:

```js
var Monads = require('control.monads')
```


### Using with AMD

[Download the latest release][release], and require the `control.monads.umd.js`
file:

```js
require(['control.monads'], function(Monads) {
  ( ... )
})
```


### Using without modules

[Download the latest release][release], and load the `control.monads.umd.js`
file. The properties are exposed in the global `Monads` object:

```html
<script src="/path/to/control.monads.umd.js"></script>
```


### Compiling from source

If you want to compile this library from the source, you'll need [Git][],
[Make][], [Node.js][], and run the following commands:

    $ git clone git://github.com/folktale/control.monads.git
    $ cd control.monads
    $ npm install
    $ make bundle
    
This will generate the `dist/control.monads.umd.js` file, which you can load in
any JavaScript environment.

    
## Documentation

You can [read the documentation online][docs] or build it yourself:

    $ git clone git://github.com/folktale/monads.maybe.git
    $ cd monads.maybe
    $ npm install
    $ make documentation

Then open the file `docs/index.html` in your browser.


## Platform support

This library assumes an ES5 environment, but can be easily supported in ES3
platforms by the use of shims. Just include [es5-shim][] :)


## Licence

Copyright (c) 2013 Quildreen Motta.

Released under the [MIT licence](https://github.com/folktale/control.monads/blob/master/LICENCE).

<!-- links -->
[Fantasy Land]: https://github.com/fantasyland/fantasy-land
[Browserify]: http://browserify.org/
[Git]: http://git-scm.com/
[Make]: http://www.gnu.org/software/make/
[Node.js]: http://nodejs.org/
[es5-shim]: https://github.com/kriskowal/es5-shim
[docs]: http://folktale.github.io/control.monads
<!-- [release: https://github.com/folktale/control.monads/releases/download/v$VERSION/control.monads-$VERSION.tar.gz] -->
[release]: https://github.com/folktale/control.monads/releases/download/v0.6.0/control.monads-0.6.0.tar.gz
<!-- [/release] -->
