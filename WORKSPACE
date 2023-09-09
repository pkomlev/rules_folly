workspace(name = "com_github_pkomlev_rules_folly")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//bazel:folly_deps.bzl", "folly_deps", "folly_library", "folly_openssl_hack")

folly_openssl_hack()

rules_boost_commit = "ba0632447cf46e43a74c4a8cbba1104e7c819bdf"

http_archive(
    name = "com_github_nelhage_rules_boost",
    sha256 = "d611bd1c598e53d6d7c11c3e426c958e9af9f12816e42c697f93ad7cc2e9b94b",
    strip_prefix = "rules_boost-{}".format(rules_boost_commit),
    urls = [
        "https://github.com/nelhage/rules_boost/archive/{}.tar.gz".format(rules_boost_commit),
    ],
)

load("@com_github_nelhage_rules_boost//:boost/boost.bzl", "boost_deps")

boost_deps()

folly_deps()

folly_library(enable_testing = True)

load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")

rules_foreign_cc_dependencies()
