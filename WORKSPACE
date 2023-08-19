workspace(name = "com_github_pkomlev_rules_folly")

load("//bazel:folly_deps.bzl", "folly_deps", "folly_library")
folly_deps()
folly_library(enable_testing = True)

load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")
rules_foreign_cc_dependencies()

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")
boost_deps()
