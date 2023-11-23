load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def folly_openssl_hack():
    maybe(
        native.new_local_repository,
        name = "openssl",
        path = "/usr/include",
        build_file = "@com_github_pkomlev_rules_folly//third_party/syslibs:openssl.BUILD",
    )

def folly_deps():
    """folly_deps sets up depencencies' git repositories folly depends on."""

    # NOTE(pkomlev): for good and bad boost and folly share several dependencies
    # and they can be found below. Here is it ensured that the repositores are
    # availabled (usually, result of boost_deps() run in the WORKSPACE file).
    boost_deps = [
        "zlib",
        "org_bzip_bzip2",
        "org_lzma_lzma",
        "com_github_facebook_zstd",
    ]

    # TODO(pkomlev): the OpenSLL dependency is not hermetic and sort of different
    # from the one used with https://github.com/nelhage/rules_boost, require repo
    # to be initialized ahead of the folly_deps call, but the actual version must
    # come from local_repository(...). The above defined folly_openssl_hack can
    # be used.
    for name in boost_deps + ["openssl"]:
        if not native.existing_rule(name):
            fail("not available repository ", name)

    maybe(
        http_archive,
        name = "rules_foreign_cc",
        sha256 = "2a4d07cd64b0719b39a7c12218a3e507672b82a97b98c6a89d38565894cf7c51",
        strip_prefix = "rules_foreign_cc-0.9.0",
        url = "https://github.com/bazelbuild/rules_foreign_cc/archive/refs/tags/0.9.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "com_github_gflags_gflags",
        sha256 = "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf",
        strip_prefix = "gflags-2.2.2",
        urls = [
            "https://github.com/gflags/gflags/archive/v2.2.2.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "com_github_google_glog",
        sha256 = "8a83bf982f37bb70825df71a9709fa90ea9f4447fb3c099e1d720a439d88bad6",
        strip_prefix = "glog-0.6.0",
        urls = [
            "https://github.com/google/glog/archive/v0.6.0.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "com_google_googletest",
        sha256 = "b4870bf121ff7795ba20d20bcdd8627b8e088f2d1dab299a031c1034eddc93d5",
        strip_prefix = "googletest-release-1.11.0",
        urls = [
            "https://github.com/google/googletest/archive/release-1.11.0.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "double-conversion",
        strip_prefix = "double-conversion-3.3.0",
        sha256 = "04ec44461850abbf33824da84978043b22554896b552c5fd11a9c5ae4b4d296e",
        urls = ["https://github.com/google/double-conversion/archive/v3.3.0.tar.gz"],
    )

    maybe(
        http_archive,
        name = "com_github_google_snappy",
        build_file = "@com_github_pkomlev_rules_folly//third_party/snappy:snappy.BUILD",
        strip_prefix = "snappy-1.1.10",
        sha256 = "49d831bffcc5f3d01482340fe5af59852ca2fe76c3e05df0e67203ebbe0f1d90",
        urls = [
            "https://github.com/google/snappy/archive/1.1.10.tar.gz",
        ],
    )

    maybe(
        http_archive,
        name = "com_github_libevent_libevent",
        sha256 = "7180a979aaa7000e1264da484f712d403fcf7679b1e9212c4e3d09f5c93efc24",
        urls = ["https://github.com/libevent/libevent/archive/release-2.1.12-stable.tar.gz"],
        strip_prefix = "libevent-release-2.1.12-stable",
        build_file = "@com_github_pkomlev_rules_folly//third_party/libevent:libevent.BUILD",
    )

    maybe(
        http_archive,
        name = "com_github_fmtlib_fmt",
        urls = ["https://github.com/fmtlib/fmt/archive/10.1.0.tar.gz"],
        sha256 = "deb0a3ad2f5126658f2eefac7bf56a042488292de3d7a313526d667f3240ca0a",
        strip_prefix = "fmt-10.1.0",
        build_file = "@com_github_pkomlev_rules_folly//third_party/fmtlib:fmtlib.BUILD",
    )

    gtest_version = "1.14.0"
    maybe(
        http_archive,
        name = "com_google_googletest",
        strip_prefix = "googletest-{}".format(gtest_version),
        urls = [
            "https://github.com/google/googletest/archive/refs/tags/v{}.tar.gz".format(gtest_version),
        ],
    )

def folly_library(enable_testing = False):
    args = {
        "with_jemalloc": 0,
        "with_lz4": 0,
        "with_unwind": 0,
        "with_dwarf": 0,
    }

    flat_args = ""
    for k, v in args.items():
        flat_args = flat_args + "%s = %d, " % (k, v)

    folly_version = "2023.11.20.00"
    http_archive(
        name = "folly",
        build_file_content = """
package(default_visibility = ["//visibility:public"])

load("@com_github_pkomlev_rules_folly//bazel:folly.bzl", "folly_config", "folly_library")

_folly_config = folly_config(%s)
folly_library(config = _folly_config, enable_testing = %s)
""" % (flat_args, "True" if enable_testing else "False"),
        strip_prefix = "folly-{}".format(folly_version),
        sha256 = "5e8730c52857d44ddbf46a819f588e036d5e6b3f5dcc7129d7bd81c372430d35",
        urls = [
            "https://github.com/facebook/folly/archive/v{}.tar.gz".format(folly_version),
        ],
        patch_args = ["-p1"],
        patches = [
            "@com_github_pkomlev_rules_folly//third_party/folly:p00_double_conversion_include_fix.patch",
        ],
    )
