# Changelog

<a name="5.1.0"></a>
## [5.1.0](https://github.com/uesteibar/neuron/compare/v5.0.0...v5.1.0) (2023-02-22)

* Support HTTPoison 2.0 (#74) ([da19f70](https://github.com/uesteibar/neuron/commit/da19f70)), closes [#74](https://github.com/uesteibar/neuron/issues/74)

### Bug Fixes

* ci(github): bump deps and switch to github actions (#72) ([c56bc74](https://github.com/uesteibar/neuron/commit/c56bc74)), closes [#72](https://github.com/uesteibar/neuron/issues/72)



<a name="5.0.0"></a>
## [5.0.0](https://github.com/uesteibar/neuron/compare/v4.1.2...v5.0.0) (2020-06-10)


### Bug Fixes

* **neuron.connection.http:** fix error case so return value matches typespec ([#60](https://github.com/uesteibar/neuron/issues/60)) ([b96d871](https://github.com/uesteibar/neuron/commit/b96d87189bb2e8194e905d0cbc7e62199d2594c3)), closes [#59](https://github.com/uesteibar/neuron/issues/59)


### BREAKING CHANGES

* **neuron.connection.http:** If your code expects the `response` field of `JSONParseError` to be a tuple, it will break.



<a name="4.1.2"></a>
## [4.1.2](https://github.com/uesteibar/neuron/compare/v4.1.1...v4.1.2) (2020-02-19)


### Bug Fixes

* **warning:**  compile time warning (default arguments in handle/3 are never used) ([75c151c](https://github.com/uesteibar/neuron/commit/75c151c))



<a name="4.1.1"></a>
## [4.1.1](https://github.com/uesteibar/neuron/compare/v4.1.0...v4.1.1) (2019-12-26)


### Bug Fixes

* **fragments:** remove duplicate fragments when inserting them into the query ([d3a5c3d](https://github.com/uesteibar/neuron/commit/d3a5c3d)), closes [#56](https://github.com/uesteibar/neuron/issues/56)



<a name="4.1.0"></a>
## [4.1.0](https://github.com/uesteibar/neuron/compare/v4.0.0...v4.1.0) (2019-11-21)


### Features

* **connection:** Allow to inject custom connection module ([f22287e](https://github.com/uesteibar/neuron/commit/f22287e))



<a name="4.0.0"></a>
## [4.0.0](https://github.com/uesteibar/neuron/compare/v3.0.1...v4.0.0) (2019-10-25)


### Bug Fixes

* **connection:** fix function signature for Neuron.Connection.post ([82817e7](https://github.com/uesteibar/neuron/commit/82817e7))
* **typespecs:** Fix typespecs for Neuron.query/3 and Neuron.Store.set/3 ([263fef4](https://github.com/uesteibar/neuron/commit/263fef4))


### Features

* **fragment:** raise `Neuron.MissingFragmentsError` for queries with missing fragments ([75ddf54](https://github.com/uesteibar/neuron/commit/75ddf54))


### BREAKING CHANGES

* **fragment:** Queries with missing fragments will now raise `Neuron.MissingFragmentsError` instead of a regular exception.



# Unreleased

* **typespecs:** Fix various type specs, specifically Neuron.query/2 can return a HTTPoison.Error.t().

<a name="3.0.1"></a>
## [3.0.1](https://github.com/uesteibar/neuron/compare/v3.0.0...v3.0.1) (2019-08-26)


### Bug Fixes

* **deps:** Make poison a test dependency ([d75e10b](https://github.com/uesteibar/neuron/commit/d75e10b))



<a name="3.0.0"></a>
## [3.0.0](https://github.com/uesteibar/neuron/compare/v2.0.0...v3.0.0) (2019-08-23)


### Features

* **json:** Use Jason as default JSOn library ([3b4e472](https://github.com/uesteibar/neuron/commit/3b4e472))


### BREAKING CHANGES

* **json:** JSON parsing library is now [Jason](https://github.com/michalmuskala/jason).
In order to keep using [Poison](https://github.com/devinus/poison)
you'll need to manually add it as a dependency and configure neuron to
use it by running `Neuron.Config.set(json_library: AnotherJSONLibrary)`.



<a name="2.0.0"></a>
## [2.0.0](https://github.com/uesteibar/neuron/compare/v1.2.0...v2.0.0) (2019-06-26)


### chore

* **deps:** Update poison to 4.0, mock to 0.3.3 and coverex to 1.5 ([600db92](https://github.com/uesteibar/neuron/commit/600db92))


### BREAKING CHANGES

* Now requires elixir >= 1.6



<a name="1.2.0"></a>
## [1.2.0](https://github.com/uesteibar/neuron/compare/v1.1.1...v1.2.0) (2019-05-30)


### Features

* **fragment:** recursively embed fragments ([3807d89](https://github.com/uesteibar/neuron/commit/3807d89))



<a name="1.1.1"></a>
## [1.1.1](https://github.com/uesteibar/neuron/compare/v1.1.0...v1.1.1) (2019-03-14)


### Bug Fixes

* **typespecs:** Fix typespec for `Neuron.query/3` ([e267f8c](https://github.com/uesteibar/neuron/commit/e267f8c)), closes [#31](https://github.com/uesteibar/neuron/issues/31)



<a name="1.1.0"></a>
## [1.1.0](https://github.com/uesteibar/neuron/compare/v1.0.0...v1.1.0) (2018-12-25)


### Features

* **decode:** Add support for passing options to the json decoder ([#29](https://github.com/uesteibar/neuron/issues/29)) ([f8425ac](https://github.com/uesteibar/neuron/commit/f8425ac))
* **options:** Allow to override connection options per request ([#30](https://github.com/uesteibar/neuron/issues/30)) ([30d99e5](https://github.com/uesteibar/neuron/commit/30d99e5))
* **response:** return a meaningful error when response is not JSON ([#27](https://github.com/uesteibar/neuron/issues/27)) ([32004b2](https://github.com/uesteibar/neuron/commit/32004b2))



<a name="1.0.0"></a>
## [1.0.0](https://github.com/uesteibar/neuron/compare/v0.9.1...v1.0.0) (2018-10-15)


### Features

* **query:** Allow passing variables ([ff82f0a](https://github.com/uesteibar/neuron/commit/ff82f0a)), closes [#25](https://github.com/uesteibar/neuron/issues/25)


### BREAKING CHANGES

  - `mutation/1` and `mutation/2` are deprecated
  - `query/2` is replaced by `query/3` to allow passing variables in



<a name="0.9.1"></a>
## [0.9.1](https://github.com/uesteibar/neuron/compare/v0.9.0...v0.9.1) (2018-09-21)


### Bug Fixes

* **headers:** Use `application/json` content type with :as_json ([f369555](https://github.com/uesteibar/neuron/commit/f369555))



<a name="0.9.0"></a>
# [0.9.0](https://github.com/uesteibar/neuron/compare/v0.8.0...v0.9.0) (2018-09-08)


### Features

* **options:** Allow to override options per request ([6ba4b39](https://github.com/uesteibar/neuron/commit/6ba4b39)), closes [#18](https://github.com/uesteibar/neuron/issues/18)



<a name="0.8.0"></a>
## [0.8.0](https://github.com/uesteibar/neuron/compare/v0.7.0...v0.8.0) (2018-08-22)


### Features

* **query:** Allow to send queries as json ([#20](https://github.com/uesteibar/neuron/issues/20)) ([c9689a8](https://github.com/uesteibar/neuron/commit/c9689a8)), closes [#19](https://github.com/uesteibar/neuron/issues/19)



<a name="0.7.0"></a>
## [0.7.0](https://github.com/uesteibar/neuron/compare/v0.6.0...v0.7.0) (2018-07-01)


### Features

* **fragments:** Allow to register fragments to fill queries automatically ([5593fc6](https://github.com/uesteibar/neuron/commit/5593fc6)), closes [#1](https://github.com/uesteibar/neuron/issues/1)



<a name="0.6.0"></a>
## [0.6.0](https://github.com/uesteibar/neuron/compare/v0.5.1...v0.6.0) (2018-05-15)


### Features

* **connection:** ability to set HTTPoison connection options (#12) ([c940965](https://github.com/uesteibar/neuron/commit/c940965))



<a name="0.5.1"></a>
## [0.5.1](https://github.com/uesteibar/neuron/compare/v0.5.0...v0.5.1) (2018-03-13)

### Docs

* docs(response): Adapt docs and tests to returning errors ([495cf61](https://github.com/uesteibar/neuron/commit/495cf61))



<a name="0.5.0"></a>
## [0.5.0](https://github.com/uesteibar/neuron/compare/v0.4.0...v0.5.0) (2018-03-13)

### BREAKING CHANGE

Now the value of response.body will be %{ data: ..., errors: ... } instead of %{ ... } (only returning data).

  * fix(response): return `errors` alongside `data` ([ce2534e](https://github.com/uesteibar/neuron/commit/ce2534e))



<a name="0.4.0"></a>
## [0.4.0](https://github.com/uesteibar/neuron/compare/v0.3.1...v0.4.0) (2018-02-27)


### Features

* **deps:** Upgrade httpoison to version 1.0 ([7f65a61](https://github.com/uesteibar/neuron/commit/7f65a61))



<a name="0.3.1"></a>
## [0.3.1](https://github.com/uesteibar/neuron/compare/v0.3.0...v0.3.1) (2017-09-05)


### Bug Fixes

* **deps:** Relax HTTPoison dependency version ([405e748](https://github.com/uesteibar/neuron/commit/405e748))



<a name="0.3.0"></a>
## [0.3.0](https://github.com/uesteibar/neuron/compare/v0.2.0...v0.3.0) (2017-09-05)


### Features

* **http:** Make it possible to add custom headers ([f54a9ff](https://github.com/uesteibar/neuron/commit/f54a9ff)),


### Bug Fixes

* **test:** Update mock/meck to fix tests on elixir 1.5 ([9768b69](https://github.com/uesteibar/neuron/commit/9768b69))



<a name="0.2.0"></a>
## [0.2.0](https://github.com/uesteibar/neuron/compare/v0.1.1...v0.2.0) (2017-05-28)


### Features

* **config:** Allow to set url globally or for current process ([3843326](https://github.com/uesteibar/neuron/commit/3843326)), closes [#2](https://github.com/uesteibar/neuron/issues/2)



<a name="0.1.1"></a>
## [0.1.1](https://github.com/uesteibar/neuron/compare/v0.1.0...v0.1.1) (2017-05-28)


### Bug Fixes

* **logging:** Remove unnecessary inspect ([6ea9240](https://github.com/uesteibar/neuron/commit/6ea9240))



<a name="0.1.0"></a>
## [0.1.0](https://github.com/uesteibar/neuron/compare/3d46dc7...v0.1.0) (2017-05-28)


### Features

* **neuron:** interact with GraphQL endpoints ([ version](https://github.com/uesteibar/neuron/commit/af142ef))
