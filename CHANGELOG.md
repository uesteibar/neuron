<a name="1.0.0"></a>
# [1.0.0](https://github.com/uesteibar/neuron/compare/v0.9.1...v1.0.0) (2018-10-15)


### Features

* **query:** Allow passing variables ([ff82f0a](https://github.com/uesteibar/neuron/commit/ff82f0a)), closes [#25](https://github.com/uesteibar/neuron/issues/25)


### BREAKING CHANGES

  - `mutation/1` and `mutation/2` are deprecated
  - `query/2` is replaced by `query/3` to allow passing variables in



<a name="0.9.1"></a>
# [0.9.1](https://github.com/uesteibar/neuron/compare/v0.9.0...v0.9.1) (2018-09-21)


### Bug Fixes

* **headers:** Use `application/json` content type with :as_json ([f369555](https://github.com/uesteibar/neuron/commit/f369555))



<a name="0.9.0"></a>
# [0.9.0](https://github.com/uesteibar/neuron/compare/v0.8.0...v0.9.0) (2018-09-08)


### Features

* **options:** Allow to override options per request ([6ba4b39](https://github.com/uesteibar/neuron/commit/6ba4b39)), closes [#18](https://github.com/uesteibar/neuron/issues/18)



<a name="0.8.0"></a>
# [0.8.0](https://github.com/uesteibar/neuron/compare/v0.7.0...v0.8.0) (2018-08-22)


### Features

* **query:** Allow to send queries as json ([#20](https://github.com/uesteibar/neuron/issues/20)) ([c9689a8](https://github.com/uesteibar/neuron/commit/c9689a8)), closes [#19](https://github.com/uesteibar/neuron/issues/19)



<a name="0.7.0"></a>
# [0.7.0](https://github.com/uesteibar/neuron/compare/v0.6.0...v0.7.0) (2018-07-01)


### Features

* **fragments:** Allow to register fragments to fill queries automatically ([5593fc6](https://github.com/uesteibar/neuron/commit/5593fc6)), closes [#1](https://github.com/uesteibar/neuron/issues/1)



<a name="0.6.0"></a>
# [0.6.0](https://github.com/uesteibar/neuron/compare/v0.5.1...v0.6.0) (2018-05-15)


### Features

* **connection:** ability to set HTTPoison connection options (#12) ([c940965](https://github.com/uesteibar/neuron/commit/c940965))



<a name="0.5.1"></a>
# [0.5.1](https://github.com/uesteibar/neuron/compare/v0.5.0...v0.5.1) (2018-03-13)

### Docs

* docs(response): Adapt docs and tests to returning errors ([495cf61](https://github.com/uesteibar/neuron/commit/495cf61))



<a name="0.5.0"></a>
# [0.5.0](https://github.com/uesteibar/neuron/compare/v0.4.0...v0.5.0) (2018-03-13)

### BREAKING CHANGE

Now the value of response.body will be %{ data: ..., errors: ... } instead of %{ ... } (only returning data).

  * fix(response): return `errors` alongside `data` ([ce2534e](https://github.com/uesteibar/neuron/commit/ce2534e))



<a name="0.4.0"></a>
# [0.4.0](https://github.com/uesteibar/neuron/compare/v0.3.1...v0.4.0) (2018-02-27)


### Features

* **deps:** Upgrade httpoison to version 1.0 ([7f65a61](https://github.com/uesteibar/neuron/commit/7f65a61))



<a name="0.3.1"></a>
# [0.3.1](https://github.com/uesteibar/neuron/compare/v0.3.0...v0.3.1) (2017-09-05)


### Bug Fixes

* **deps:** Relax HTTPoison dependency version ([405e748](https://github.com/uesteibar/neuron/commit/405e748))



<a name="0.3.0"></a>
# [0.3.0](https://github.com/uesteibar/neuron/compare/v0.2.0...v0.3.0) (2017-09-05)


### Features

* **http:** Make it possible to add custom headers ([f54a9ff](https://github.com/uesteibar/neuron/commit/f54a9ff)),


### Bug Fixes

* **test:** Update mock/meck to fix tests on elixir 1.5 ([9768b69](https://github.com/uesteibar/neuron/commit/9768b69))



<a name="0.2.0"></a>
# [0.2.0](https://github.com/uesteibar/neuron/compare/v0.1.1...v0.2.0) (2017-05-28)


### Features

* **config:** Allow to set url globally or for current process ([3843326](https://github.com/uesteibar/neuron/commit/3843326)), closes [#2](https://github.com/uesteibar/neuron/issues/2)



<a name="0.1.1"></a>
## [0.1.1](https://github.com/uesteibar/neuron/compare/v0.1.0...v0.1.1) (2017-05-28)


### Bug Fixes

* **logging:** Remove unnecessary inspect ([6ea9240](https://github.com/uesteibar/neuron/commit/6ea9240))



<a name="0.1.0"></a>
# [0.1.0](https://github.com/uesteibar/neuron/compare/3d46dc7...v0.1.0) (2017-05-28)


### Features

* **neuron:** interact with GraphQL endpoints ([ version](https://github.com/uesteibar/neuron/commit/af142ef))
