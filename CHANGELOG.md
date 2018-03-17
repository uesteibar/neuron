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
