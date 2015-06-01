coffeelint-no-implicit-returns
==============================

CoffeeLint rule that checks for explicit returns in multi-line functions

Description
-----------

This [CoffeeLint](http://www.coffeelint.org/) rule verifies that multi-line functions have an
explicit return statement.

Installation
------------

```sh
npm install coffeelint-no-implicit-returns
```

Usage
-----

Add the following configuration to `coffeelint.json`:

```json
"no_implicit_returns": {
  "module": "coffeelint-no-implicit-returns"
}
```

Configuration
-------------

**strict**: If false, single-expression functions that spans multiple lines are
allowed.

Example:

```json
"no_implicit_returns": {
  "module": "coffeelint-no-implicit-returns",
  "strict": false
}
```
