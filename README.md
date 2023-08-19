# `rules_folly` -- Bazel Build Rules for Folly

This reposotory contains Bazel rules for Meta's [Folly](https://github.com/facebook/folly) library, a fork of now seemingly abandoned [storypku/rules_folly](https://github.com/storypku/rules_folly). 

## Pre-requisites
Currently the dependency on Open SSL is not hermetic. The host machine should have `libssl-dev` installed.

### Ubuntu:

```bash
sudo apt-get update \
sudo apt-get -y install libssl-dev
```

## How To Use

In your `WORKSPACE` file, add the following:

```
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "com_github_pkomlev_rules_folly",
    remote = "https://github.com/pkomlev/rules_folly.git",
    branch = "master",
)

load("@com_github_pkomlev_rules_folly//bazel:folly_deps.bzl", "folly_deps", "folly_library")
folly_deps()
folly_library()

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")
boost_deps()

load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")
rules_foreign_cc_dependencies()
```

> TODO(pkomlev): describe library depednecies configuration.

Then you can add Folly in the `deps` section of target cc rule in the `BUILD` file:

```
cc_library(
    name = "example"
    deps = ["@folly//:folly"],
    ...
),
```

Note that most of the Folly libraries require `-std=c++17` standard, and some -- `-std=c++2a`, so the appropriate copts appropriately (Bazel command line argument, `.bazelrc`, or on per target basis).

## Tests
Folly is supplied with unit tests, and various performance benchmarks. By default those are not included as a part of the build, but they can be enabled via parameter of the `folly_library(...)` rule.

```
...
load("@com_github_pkomlev_rules_folly//bazel:folly_deps.bzl", "folly_deps", "folly_library")
folly_deps()
folly_library(enable_testing=True)
```

Once enabled, tests those can be run with `bazel test -c opt @folly//...`.

## Roadmap

> TODO(pkomlev): the following section is largely out of sync, update.

- openssl saga:
 - hermetic builds (no dependency on local)
 - make configurable: openssl or boringssl
- test and support macos builds
- folly-python
- support experimental libraries (liburing etc.)
