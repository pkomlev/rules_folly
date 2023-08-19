""" Provides definition of the tests tests in folly libarary. """

def _make_test_def(**kvargs):
    return struct(**kvargs)

def folly_tests_def():
    """Merges CMake data and hacky-patch, retruns all test definitions."""

    dummy = {"hdrs": [], "tags": []}

    tests = []
    for path, suite in _folly_cmake_content.items():
        for name, test_def in suite.items():
            patch = _folly_cmake_patch.get(path, {}).get(name, dummy)
            tests.append(_make_test_def(
                path = path,
                name = name,
                srcs = test_def.get("srcs", []),
                hdrs = test_def.get("hdrs", []) + patch.get("hdrs", []),
                tags = test_def.get("tags", []) + patch.get("tags", []),
                benchmark = test_def.get("benchmark", 0),
            ))

    return tests

# NOTE(pkomlev): The following is generated using the code pasted in the comments below.
# The code parses definition of tests in Folly's CMakeFile.txt, produced the very same
# definitions for the bazel, in a more manageable form (no CMake).
#
# TODO(pkomlev): There are "bugs" here and there (see "patch" logic), and this cannot
# easily run at the build time. Hope number of patches and hack will decrease over time.
#
# --------------------------------------------------------------------------------------
#
# from cmakeast import ast, ast_visitor
#
# import sys
# import json
#
# tree = ast.parse(open(sys.argv[1], "rt").read())
#
# tests = {}
#
#
# def parse_folly_test(args):
#     result = []
#     for arg in args:
#         if (
#             arg.type != ast.WordType.Variable
#             and arg.type != ast.WordType.CompoundLiteral
#         ):
#             raise Exception(arg)
#         result.append(arg.contents)
#     return result
#
#
# def print_node(node_name, node, _depth):
#     if node_name != "FunctionCall" or node[0] != "folly_define_tests":
#         return
#
#     tokens = parse_folly_test(node[1])
#
#     curr = 0
#     while curr < len(tokens):
#         if tokens[curr] == "DIRECTORY":
#             curr += 1
#         assert curr < len(tokens), "Expected base directory."
#
#         dir = tokens[curr]
#         curr += 1
#
#         while curr < len(tokens):
#             if tokens[curr] == "DIRECTORY":
#                 break
#
#             is_test = {"TEST": True, "BENCHMARK": False}.get(tokens[curr])
#             assert (
#                 not is_test is None
#             ), f"Unknown arg inside directory - {tokens[curr]}."
#
#             curr += 1
#             assert curr < len(tokens), "Expected test name."
#             test = tokens[curr]
#
#             tags = set()
#             srcs = []
#             hdrs = []
#             data = []
#
#             handler = lambda x: None
#             while curr < len(tokens):
#                 if tokens[curr] in {"DIRECTORY", "TEST", "BENCHMARK"}:
#                     break
#
#                 if tokens[curr] in {
#                     "WINDOWS_DISABLED",
#                     "APPLE_DISABLED",
#                     "HANGING",
#                     "BROKEN",
#                     "SLOW",
#                 }:
#                     tags.add(tokens[curr])
#                 elif tokens[curr] == "HEADERS":
#                     handler = lambda x: hdrs.append(x)
#                 elif tokens[curr] == "SOURCES":
#                     handler = lambda x: srcs.append(x)
#                 elif tokens[curr] == "CONTENT_DIR":
#                     handler = lambda x: data.append(x)
#                 else:
#                     handler(tokens[curr])
#
#                 curr += 1
#
#             value = {"srcs": srcs}
#             if tags:
#                 value["tags"] = [tag for tag in tags]
#             if hdrs:
#                 value["hdrs"] = hdrs
#             if data:
#                 value["data"] = data
#             if not is_test:
#                 value["benchmark"] = 1
#
#             suite = tests.get(dir, {})
#             suite[test] = value
#             tests[dir] = suite
#
#
# ast_visitor.recurse(tree, function_call=print_node)
# print(json.dumps(tests, sort_keys=True, indent=4))

_folly_cmake_content = {
    "chrono/test/": {
        "chrono_conv_test": {"srcs": ["ConvTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
    },
    "compression/test/": {
        "compression_test": {"srcs": ["CompressionTest.cpp"], "tags": ["SLOW"]},
    },
    "concurrency/test/": {
        "atomic_shared_ptr_test": {"srcs": ["AtomicSharedPtrTest.cpp"]},
        "cache_locality_test": {
            "srcs": ["CacheLocalityTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "concurrent_hash_map_benchmark": {
            "benchmark": 1,
            "srcs": ["ConcurrentHashMapBench.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "concurrent_hash_map_test": {
            "srcs": ["ConcurrentHashMapTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "core_cached_shared_ptr_test": {"srcs": ["CoreCachedSharedPtrTest.cpp"]},
        "dynamic_bounded_queue_test": {
            "srcs": ["DynamicBoundedQueueTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "priority_unbounded_queue_set_test": {
            "srcs": ["PriorityUnboundedQueueSetTest.cpp"],
        },
        "thread_cached_synchronized_benchmark": {
            "benchmark": 1,
            "srcs": ["ThreadCachedSynchronizedBench.cpp"],
        },
        "thread_cached_synchronized_test": {
            "srcs": ["ThreadCachedSynchronizedTest.cpp"],
        },
        "unbounded_queue_test": {"srcs": ["UnboundedQueueTest.cpp"]},
    },
    "container/test/": {
        "access_test": {"srcs": ["AccessTest.cpp"]},
        "array_test": {"srcs": ["ArrayTest.cpp"]},
        "bit_iterator_benchmark": {"benchmark": 1, "srcs": ["BitIteratorBench.cpp"]},
        "bit_iterator_test": {"srcs": ["BitIteratorTest.cpp"]},
        "enumerate_test": {"srcs": ["EnumerateTest.cpp"]},
        "evicting_cache_map_benchmark": {
            "benchmark": 1,
            "srcs": ["EvictingCacheMapBench.cpp"],
        },
        "evicting_cache_map_test": {"srcs": ["EvictingCacheMapTest.cpp"]},
        "f14_fwd_test": {"srcs": ["F14FwdTest.cpp"]},
        "f14_map_test": {"srcs": ["F14MapTest.cpp"]},
        "f14_set_test": {"srcs": ["F14SetTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "foreach_benchmark": {"benchmark": 1, "srcs": ["ForeachBenchmark.cpp"]},
        "foreach_test": {"srcs": ["ForeachTest.cpp"]},
        "heap_vector_types_test": {"srcs": ["heap_vector_types_test.cpp"]},
        "merge_test": {"srcs": ["MergeTest.cpp"]},
        "sparse_byte_set_benchmark": {
            "benchmark": 1,
            "srcs": ["SparseByteSetBenchmark.cpp"],
        },
        "sparse_byte_set_test": {"srcs": ["SparseByteSetTest.cpp"]},
        "util_test": {"srcs": ["UtilTest.cpp"]},
    },
    "detail/base64_detail/tests/": {
        "base64_detail_test": {
            "srcs": [
                "Base64AgainstScalarTest.cpp",
                "Base64PlatformTest.cpp",
                "Base64SpecialCasesTest.cpp",
            ],
        },
    },
    "detail/test/": {
        "simd_for_each_test": {"srcs": ["SimdForEachTest.cpp"]},
        "simple_simd_string_utils_test": {"srcs": ["SimpleSimdStringUtilsTest.cpp"]},
        "split_string_simd_test": {"srcs": ["SplitStringSimdTest.cpp"]},
        "static_singleton_manager_test": {"srcs": ["StaticSingletonManagerTest.cpp"]},
        "unroll_utils_test": {"srcs": ["UnrollUtilsTest.cpp"]},
    },
    "executors/task_queue/test/": {
        "priority_unbounded_blocking_queue_test": {
            "srcs": ["PriorityUnboundedBlockingQueueTest.cpp"],
        },
        "unbounded_blocking_queue_benchmark": {
            "benchmark": 1,
            "srcs": ["UnboundedBlockingQueueBench.cpp"],
        },
        "unbounded_blocking_queue_test": {"srcs": ["UnboundedBlockingQueueTest.cpp"]},
    },
    "executors/test/": {
        "async_helpers_test": {"srcs": ["AsyncTest.cpp"]},
        "codel_test": {"srcs": ["CodelTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "edf_thread_pool_executor_benchmark": {
            "benchmark": 1,
            "srcs": ["EDFThreadPoolExecutorBenchmark.cpp"],
        },
        "executor_test": {"srcs": ["ExecutorTest.cpp"]},
        "fiber_io_executor_test": {
            "srcs": ["FiberIOExecutorTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "global_executor_test": {"srcs": ["GlobalExecutorTest.cpp"]},
        "serial_executor_test": {"srcs": ["SerialExecutorTest.cpp"]},
        "thread_pool_executor_test": {
            "srcs": ["ThreadPoolExecutorTest.cpp"],
            "tags": ["BROKEN", "WINDOWS_DISABLED"],
        },
        "threaded_executor_test": {"srcs": ["ThreadedExecutorTest.cpp"]},
        "timed_drivable_executor_test": {"srcs": ["TimedDrivableExecutorTest.cpp"]},
    },
    "experimental/crypto/test/": {
        "blake2xb_test": {"srcs": ["Blake2xbTest.cpp"]},
        "lt_hash_test": {"srcs": ["LtHashTest.cpp"]},
    },
    "experimental/io/test/": {
        "async_io_test": {
            "srcs": [
                "AsyncIOTest.cpp",
                "AsyncBaseTestLib.cpp",
                "IoTestTempFileUtil.cpp",
            ],
        },
        "fs_util_test": {"srcs": ["FsUtilTest.cpp"]},
    },
    "experimental/test/": {
        "autotimer_test": {"srcs": ["AutoTimerTest.cpp"]},
        "bits_test_2": {"srcs": ["BitsTest.cpp"]},
        "bitvector_test": {"srcs": ["BitVectorCodingTest.cpp"]},
        "dynamic_parser_test": {"srcs": ["DynamicParserTest.cpp"]},
        "eliasfano_test": {"srcs": ["EliasFanoCodingTest.cpp"]},
        "event_count_test": {"srcs": ["EventCountTest.cpp"]},
        "function_scheduler_test": {
            "srcs": ["FunctionSchedulerTest.cpp"],
            "tags": ["BROKEN"],
        },
        "future_dag_test": {"srcs": ["FutureDAGTest.cpp"]},
        "json_schema_test": {"srcs": ["JSONSchemaTest.cpp"]},
        "lock_free_ring_buffer_test": {"srcs": ["LockFreeRingBufferTest.cpp"]},
        "quotient_multiset_test": {"srcs": ["QuotientMultiSetTest.cpp"]},
        "select64_test": {"srcs": ["Select64Test.cpp"]},
        "string_keyed_benchmark": {
            "benchmark": 1,
            "srcs": ["StringKeyedBenchmark.cpp"],
        },
        "stringkeyed_test": {"srcs": ["StringKeyedTest.cpp"]},
        "test_util_test": {"srcs": ["TestUtilTest.cpp"]},
        "tuple_ops_test": {"srcs": ["TupleOpsTest.cpp"]},
    },
    "external/farmhash/test/": {"farmhash_test": {"srcs": ["farmhash_test.cpp"]}},
    "fibers/test/": {
        "fibers_benchmark": {"benchmark": 1, "srcs": ["FibersBenchmark.cpp"]},
        "fibers_test": {"srcs": ["FibersTest.cpp"], "tags": ["BROKEN"]},
    },
    "functional/test/": {
        "apply_tuple_test": {
            "srcs": ["ApplyTupleTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "partial_test": {"srcs": ["PartialTest.cpp"]},
    },
    "futures/test/": {
        "barrier_test": {"srcs": ["BarrierTest.cpp"]},
        "callback_lifetime_test": {"srcs": ["CallbackLifetimeTest.cpp"]},
        "collect_test": {"srcs": ["CollectTest.cpp"]},
        "context_test": {"srcs": ["ContextTest.cpp"]},
        "core_test": {"srcs": ["CoreTest.cpp"]},
        "ensure_test": {"srcs": ["EnsureTest.cpp"]},
        "filter_test": {"srcs": ["FilterTest.cpp"]},
        "future_splitter_test": {"srcs": ["FutureSplitterTest.cpp"]},
        "future_test": {"srcs": ["FutureTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "futures_benchmark": {
            "benchmark": 1,
            "srcs": ["Benchmark.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "header_compile_test": {"srcs": ["HeaderCompileTest.cpp"]},
        "interrupt_test": {"srcs": ["InterruptTest.cpp"]},
        "map_test": {"srcs": ["MapTest.cpp"]},
        "non_copyable_lambda_test": {"srcs": ["NonCopyableLambdaTest.cpp"]},
        "poll_test": {"srcs": ["PollTest.cpp"]},
        "promise_test": {"srcs": ["PromiseTest.cpp"]},
        "reduce_test": {"srcs": ["ReduceTest.cpp"]},
        "retrying_test": {"srcs": ["RetryingTest.cpp"]},
        "self_destruct_test": {"srcs": ["SelfDestructTest.cpp"]},
        "shared_promise_test": {"srcs": ["SharedPromiseTest.cpp"]},
        "test_executor_test": {"srcs": ["TestExecutorTest.cpp"]},
        "then_compile_test": {
            "hdrs": ["ThenCompileTest.h"],
            "srcs": ["ThenCompileTest.cpp"],
        },
        "then_test": {"srcs": ["ThenTest.cpp"]},
        "timekeeper_test": {
            "srcs": ["TimekeeperTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "times_test": {"srcs": ["TimesTest.cpp"]},
        "unwrap_test": {"srcs": ["UnwrapTest.cpp"]},
        "via_test": {"srcs": ["ViaTest.cpp"]},
        "wait_test": {"srcs": ["WaitTest.cpp"]},
        "when_test": {"srcs": ["WhenTest.cpp"]},
        "while_do_test": {"srcs": ["WhileDoTest.cpp"]},
        "will_equal_test": {"srcs": ["WillEqualTest.cpp"]},
        "window_test": {"srcs": ["WindowTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
    },
    "gen/test/": {
        "combine_test": {"srcs": ["CombineTest.cpp"]},
        "parallel_benchmark": {"benchmark": 1, "srcs": ["ParallelBenchmark.cpp"]},
        "parallel_map_benchmark": {
            "benchmark": 1,
            "srcs": ["ParallelMapBenchmark.cpp"],
        },
        "parallel_map_test": {"srcs": ["ParallelMapTest.cpp"]},
        "parallel_test": {"srcs": ["ParallelTest.cpp"]},
    },
    "hash/test/": {
        "checksum_benchmark": {"benchmark": 1, "srcs": ["ChecksumBenchmark.cpp"]},
        "checksum_test": {"srcs": ["ChecksumTest.cpp"]},
        "farm_hash_test": {"srcs": ["FarmHashTest.cpp"]},
        "hash_benchmark": {
            "benchmark": 1,
            "srcs": ["HashBenchmark.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "hash_test": {"srcs": ["HashTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "spooky_hash_v1_test": {"srcs": ["SpookyHashV1Test.cpp"]},
        "spooky_hash_v2_test": {"srcs": ["SpookyHashV2Test.cpp"]},
    },
    "io/async/ssl/test/": {"ssl_errors_test": {"srcs": ["SSLErrorsTest.cpp"]}},
    "io/async/test/": {
        "AsyncUDPSocketTest": {
            "srcs": ["AsyncUDPSocketTest.cpp"],
            "tags": ["WINDOWS_DISABLED", "APPLE_DISABLED"],
        },
        "DelayedDestructionBaseTest": {"srcs": ["DelayedDestructionBaseTest.cpp"]},
        "DelayedDestructionTest": {"srcs": ["DelayedDestructionTest.cpp"]},
        "DestructorCheckTest": {"srcs": ["DestructorCheckTest.cpp"]},
        "EventBaseLocalTest": {
            "srcs": ["EventBaseLocalTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "EventBaseTest": {"srcs": ["EventBaseTest.cpp"], "tags": ["BROKEN"]},
        "HHWheelTimerSlowTests": {
            "srcs": ["HHWheelTimerSlowTests.cpp"],
            "tags": ["SLOW"],
        },
        "HHWheelTimerTest": {"srcs": ["HHWheelTimerTest.cpp"]},
        "NotificationQueueTest": {
            "srcs": ["NotificationQueueTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "RequestContextTest": {
            "srcs": ["RequestContextTest.cpp", "RequestContextHelper.h"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "ScopedEventBaseThreadTest": {
            "srcs": ["ScopedEventBaseThreadTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "async_test": {
            "data": ["certs/"],
            "hdrs": ["AsyncSocketTest.h", "AsyncSSLSocketTest.h"],
            "srcs": [
                "AsyncPipeTest.cpp",
                "AsyncSocketExceptionTest.cpp",
                "AsyncSocketTest.cpp",
                "AsyncSocketTest2.cpp",
                "AsyncSSLSocketTest.cpp",
                "AsyncSSLSocketTest2.cpp",
                "AsyncSSLSocketWriteTest.cpp",
                "AsyncTransportTest.cpp",
            ],
            "tags": ["BROKEN"],
        },
        "async_timeout_test": {"srcs": ["AsyncTimeoutTest.cpp"]},
        "request_context_benchmark": {
            "benchmark": 1,
            "hdrs": ["RequestContextHelper.h"],
            "srcs": ["RequestContextBenchmark.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "ssl_session_test": {"data": ["certs/"], "srcs": ["SSLSessionTest.cpp"]},
        "writechain_test": {"srcs": ["WriteChainAsyncTransportWrapperTest.cpp"]},
    },
    "io/test/": {
        "ShutdownSocketSetTest": {
            "srcs": ["ShutdownSocketSetTest.cpp"],
            "tags": ["HANGING"],
        },
        "iobuf_cursor_test": {"srcs": ["IOBufCursorTest.cpp"]},
        "iobuf_queue_test": {"srcs": ["IOBufQueueTest.cpp"]},
        "iobuf_test": {"srcs": ["IOBufTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "record_io_test": {"srcs": ["RecordIOTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
    },
    "lang/test/": {
        "lang_aligned_test": {"srcs": ["AlignedTest.cpp"]},
        "lang_badge_test": {"srcs": ["BadgeTest.cpp"]},
        "lang_bits_test": {"srcs": ["BitsTest.cpp"]},
        "lang_byte_test": {"srcs": ["ByteTest.cpp"]},
        "lang_c_string_test": {"srcs": ["CStringTest.cpp"]},
        "lang_cast_test": {"srcs": ["CastTest.cpp"]},
        "lang_checked_math_test": {"srcs": ["CheckedMathTest.cpp"]},
        "lang_exception_test": {"srcs": ["ExceptionTest.cpp"]},
        "lang_extern_test": {"srcs": ["ExternTest.cpp"]},
        "lang_launder_test": {"srcs": ["LaunderTest.cpp"]},
        "lang_ordering_test": {"srcs": ["OrderingTest.cpp"]},
        "lang_pretty_test": {"srcs": ["PrettyTest.cpp"]},
        "lang_propagate_const_test": {"srcs": ["PropagateConstTest.cpp"]},
        "lang_r_value_reference_wrapper_test": {
            "srcs": ["RValueReferenceWrapperTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "lang_safe_assert_test": {"srcs": ["SafeAssertTest.cpp"]},
        "lang_to_ascii_benchmark": {"benchmark": 1, "srcs": ["ToAsciiBench.cpp"]},
        "lang_to_ascii_test": {"srcs": ["ToAsciiTest.cpp"]},
        "lang_type_info_test": {"srcs": ["TypeInfoTest.cpp"]},
        "lang_uncaught_exceptions_test": {"srcs": ["UncaughtExceptionsTest.cpp"]},
    },
    "logging/test/": {
        "async_file_writer_test": {
            "srcs": ["AsyncFileWriterTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "config_parser_test": {"srcs": ["ConfigParserTest.cpp"]},
        "config_update_test": {"srcs": ["ConfigUpdateTest.cpp"]},
        "file_handler_factory_test": {
            "srcs": ["FileHandlerFactoryTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "glog_formatter_test": {"srcs": ["GlogFormatterTest.cpp"]},
        "immediate_file_writer_test": {"srcs": ["ImmediateFileWriterTest.cpp"]},
        "log_category_test": {"srcs": ["LogCategoryTest.cpp"]},
        "log_level_test": {"srcs": ["LogLevelTest.cpp"]},
        "log_message_test": {"srcs": ["LogMessageTest.cpp"]},
        "log_name_test": {"srcs": ["LogNameTest.cpp"]},
        "log_stream_test": {"srcs": ["LogStreamTest.cpp"]},
        "logger_db_test": {"srcs": ["LoggerDBTest.cpp"]},
        "logger_test": {"srcs": ["LoggerTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "rate_limiter_test": {"srcs": ["RateLimiterTest.cpp"]},
        "standard_log_handler_test": {"srcs": ["StandardLogHandlerTest.cpp"]},
        "xlog_test": {
            "hdrs": ["XlogHeader1.h", "XlogHeader2.h"],
            "srcs": ["XlogFile1.cpp", "XlogFile2.cpp", "XlogTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
    },
    "memory/test/": {
        "arena_test": {"srcs": ["ArenaTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "mallctl_helper_test": {"srcs": ["MallctlHelperTest.cpp"]},
        "reentrant_allocator_test": {
            "srcs": ["ReentrantAllocatorTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "thread_cached_arena_test": {
            "srcs": ["ThreadCachedArenaTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "uninitialized_memory_hacks_test": {
            "srcs": ["UninitializedMemoryHacksTest.cpp"],
        },
    },
    "net/detail/test/": {
        "socket_file_descriptor_map_test": {"srcs": ["SocketFileDescriptorMapTest.cpp"]},
    },
    "portability/test/": {
        "constexpr_test": {"srcs": ["ConstexprTest.cpp"]},
        "filesystem_test": {"srcs": ["FilesystemTest.cpp"]},
        "libgen-test": {"srcs": ["LibgenTest.cpp"]},
        "openssl_portability_test": {"srcs": ["OpenSSLPortabilityTest.cpp"]},
        "pthread_test": {"srcs": ["PThreadTest.cpp"]},
        "time-test": {"srcs": ["TimeTest.cpp"]},
    },
    "ssl/test/": {"openssl_hash_test": {"srcs": ["OpenSSLHashTest.cpp"]}},
    "stats/test/": {
        "buffered_stat_test": {"srcs": ["BufferedStatTest.cpp"]},
        "digest_builder_benchmark": {
            "benchmark": 1,
            "srcs": ["DigestBuilderBenchmark.cpp"],
        },
        "digest_builder_test": {"srcs": ["DigestBuilderTest.cpp"]},
        "histogram_benchmark": {"benchmark": 1, "srcs": ["HistogramBenchmark.cpp"]},
        "histogram_test": {"srcs": ["HistogramTest.cpp"]},
        "quantile_estimator_test": {"srcs": ["QuantileEstimatorTest.cpp"]},
        "quantile_histogram_benchmark": {
            "benchmark": 1,
            "srcs": ["QuantileHistogramBenchmark.cpp"],
        },
        "sliding_window_test": {"srcs": ["SlidingWindowTest.cpp"]},
        "tdigest_benchmark": {"benchmark": 1, "srcs": ["TDigestBenchmark.cpp"]},
        "tdigest_test": {"srcs": ["TDigestTest.cpp"]},
        "timeseries_histogram_test": {"srcs": ["TimeseriesHistogramTest.cpp"]},
        "timeseries_test": {"srcs": ["TimeSeriesTest.cpp"]},
    },
    "synchronization/detail/test/": {"hardware_test": {"srcs": ["HardwareTest.cpp"]}},
    "synchronization/test/": {
        "atomic_struct_test": {"srcs": ["AtomicStructTest.cpp"]},
        "atomic_util_test": {"srcs": ["AtomicUtilTest.cpp"]},
        "baton_benchmark": {"benchmark": 1, "srcs": ["BatonBenchmark.cpp"]},
        "baton_test": {"srcs": ["BatonTest.cpp"]},
        "call_once_test": {"srcs": ["CallOnceTest.cpp"]},
        "lifo_sem_test": {"srcs": ["LifoSemTests.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "relaxed_atomic_test": {
            "srcs": ["RelaxedAtomicTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "rw_spin_lock_test": {"srcs": ["RWSpinLockTest.cpp"]},
        "semaphore_test": {"srcs": ["SemaphoreTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "small_locks_test": {"srcs": ["SmallLocksTest.cpp"]},
    },
    "system/test/": {
        "memory_mapping_test": {"srcs": ["MemoryMappingTest.cpp"]},
        "shell_test": {"srcs": ["ShellTest.cpp"]},
        "thread_id_test": {"srcs": ["ThreadIdTest.cpp"]},
        "thread_name_test": {
            "srcs": ["ThreadNameTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
    },
    "test/": {
        "ahm_int_stress_test": {"srcs": ["AHMIntStressTest.cpp"]},
        "arena_smartptr_test": {"srcs": ["ArenaSmartPtrTest.cpp"]},
        "ascii_case_insensitive_benchmark": {
            "benchmark": 1,
            "srcs": ["AsciiCaseInsensitiveBenchmark.cpp"],
        },
        "ascii_check_test": {"srcs": ["AsciiCaseInsensitiveTest.cpp"]},
        "atomic_hash_array_test": {"srcs": ["AtomicHashArrayTest.cpp"]},
        "atomic_hash_map_test": {
            "srcs": ["AtomicHashMapTest.cpp"],
            "tags": ["HANGING"],
        },
        "atomic_linked_list_test": {"srcs": ["AtomicLinkedListTest.cpp"]},
        "atomic_unordered_map_test": {"srcs": ["AtomicUnorderedMapTest.cpp"]},
        "base64_test": {"srcs": ["base64_test.cpp"]},
        "clock_gettime_wrappers_test": {"srcs": ["ClockGettimeWrappersTest.cpp"]},
        "concurrent_bit_set_test": {"srcs": ["ConcurrentBitSetTest.cpp"]},
        "concurrent_skip_list_benchmark": {
            "benchmark": 1,
            "srcs": ["ConcurrentSkipListBenchmark.cpp"],
        },
        "concurrent_skip_list_test": {"srcs": ["ConcurrentSkipListTest.cpp"]},
        "conv_test": {"srcs": ["ConvTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "cpu_id_test": {"srcs": ["CpuIdTest.cpp"]},
        "demangle_test": {"srcs": ["DemangleTest.cpp"]},
        "deterministic_schedule_test": {"srcs": ["DeterministicScheduleTest.cpp"]},
        "discriminated_ptr_test": {"srcs": ["DiscriminatedPtrTest.cpp"]},
        "dynamic_converter_test": {"srcs": ["DynamicConverterTest.cpp"]},
        "dynamic_other_test": {"srcs": ["DynamicOtherTest.cpp"]},
        "dynamic_test": {"srcs": ["DynamicTest.cpp"]},
        "endian_test": {"srcs": ["EndianTest.cpp"]},
        "exception_test": {"srcs": ["ExceptionTest.cpp"]},
        "exception_wrapper_benchmark": {
            "benchmark": 1,
            "srcs": ["ExceptionWrapperBenchmark.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "exception_wrapper_test": {
            "srcs": ["ExceptionWrapperTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "expected_test": {"srcs": ["ExpectedTest.cpp"]},
        "fbstring_benchmark": {
            "benchmark": 1,
            "hdrs": ["FBStringTestBenchmarks.cpp.h"],
            "srcs": ["FBStringBenchmark.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "fbstring_test": {"srcs": ["FBStringTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "fbvector_benchmark": {
            "benchmark": 1,
            "hdrs": ["FBVectorBenchmarks.cpp.h"],
            "srcs": ["FBVectorBenchmark.cpp"],
        },
        "fbvector_test": {"srcs": ["FBVectorTest.cpp"]},
        "file_test": {"srcs": ["FileTest.cpp"]},
        "file_util_test": {"srcs": ["FileUtilTest.cpp"]},
        "fingerprint_benchmark": {"benchmark": 1, "srcs": ["FingerprintBenchmark.cpp"]},
        "fingerprint_test": {"srcs": ["FingerprintTest.cpp"]},
        "fixed_string_test": {"srcs": ["FixedStringTest.cpp"]},
        "format_benchmark": {"benchmark": 1, "srcs": ["FormatBenchmark.cpp"]},
        "format_other_test": {"srcs": ["FormatOtherTest.cpp"]},
        "format_test": {"srcs": ["FormatTest.cpp"]},
        "function_ref_benchmark": {
            "benchmark": 1,
            "srcs": ["FunctionRefBenchmark.cpp"],
        },
        "function_ref_test": {"srcs": ["FunctionRefTest.cpp"]},
        "function_test": {"srcs": ["FunctionTest.cpp"], "tags": ["BROKEN"]},
        "futex_test": {"srcs": ["FutexTest.cpp"]},
        "glog_test": {"srcs": ["GLogTest.cpp"]},
        "group_varint_test": {"srcs": ["GroupVarintTest.cpp"]},
        "group_varint_test_ssse3": {"srcs": ["GroupVarintTest.cpp"]},
        "indestructible_test": {"srcs": ["IndestructibleTest.cpp"]},
        "indexed_mem_pool_test": {
            "srcs": ["IndexedMemPoolTest.cpp"],
            "tags": ["BROKEN"],
        },
        "iterators_test": {"srcs": ["IteratorsTest.cpp"]},
        "json_benchmark": {"benchmark": 1, "srcs": ["JsonBenchmark.cpp"]},
        "json_other_test": {"srcs": ["JsonOtherTest.cpp"]},
        "json_patch_test": {"srcs": ["json_patch_test.cpp"]},
        "json_pointer_test": {"srcs": ["json_pointer_test.cpp"]},
        "json_test": {"srcs": ["JsonTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "lazy_test": {"srcs": ["LazyTest.cpp"]},
        "locks_test": {"srcs": ["SpinLockTest.cpp"]},
        "map_util_test": {"srcs": ["MapUtilTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "math_test": {"srcs": ["MathTest.cpp"]},
        "memcpy_test": {"srcs": ["MemcpyTest.cpp"]},
        "memory_idler_test": {"srcs": ["MemoryIdlerTest.cpp"]},
        "memory_test": {"srcs": ["MemoryTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "move_wrapper_test": {"srcs": ["MoveWrapperTest.cpp"]},
        "mpmc_pipeline_test": {"srcs": ["MPMCPipelineTest.cpp"]},
        "mpmc_queue_test": {"srcs": ["MPMCQueueTest.cpp"], "tags": ["SLOW"]},
        "network_address_test": {
            "srcs": [
                "IPAddressTest.cpp",
                "MacAddressTest.cpp",
                "SocketAddressTest.cpp",
            ],
            "tags": ["HANGING"],
        },
        "optional_test": {"srcs": ["OptionalTest.cpp"]},
        "packed_sync_ptr_test": {
            "srcs": ["PackedSyncPtrTest.cpp"],
            "tags": ["HANGING"],
        },
        "padded_test": {"srcs": ["PaddedTest.cpp"]},
        "portability_test": {"srcs": ["PortabilityTest.cpp"]},
        "producer_consumer_queue_benchmark": {
            "benchmark": 1,
            "srcs": ["ProducerConsumerQueueBenchmark.cpp"],
            "tags": ["APPLE_DISABLED"],
        },
        "producer_consumer_queue_test": {
            "srcs": ["ProducerConsumerQueueTest.cpp"],
            "tags": ["SLOW"],
        },
        "random_test": {"srcs": ["RandomTest.cpp"]},
        "range_find_benchmark": {"benchmark": 1, "srcs": ["RangeFindBenchmark.cpp"]},
        "range_test": {"srcs": ["RangeTest.cpp"]},
        "replaceable_test": {
            "srcs": ["ReplaceableTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "scope_guard_test": {
            "srcs": ["ScopeGuardTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "singleton_test_global": {"srcs": ["SingletonTestGlobal.cpp"]},
        "singleton_thread_local_test": {"srcs": ["SingletonThreadLocalTest.cpp"]},
        "small_vector_test": {
            "srcs": ["small_vector_test.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "sorted_vector_types_test": {"srcs": ["sorted_vector_test.cpp"]},
        "string_benchmark": {
            "benchmark": 1,
            "srcs": ["StringBenchmark.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "string_test": {"srcs": ["StringTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "synchronized_benchmark": {
            "benchmark": 1,
            "srcs": ["SynchronizedBenchmark.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "synchronized_test": {
            "srcs": ["SynchronizedTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "thread_cached_int_test": {
            "srcs": ["ThreadCachedIntTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "thread_local_test": {
            "srcs": ["ThreadLocalTest.cpp"],
            "tags": ["WINDOWS_DISABLED"],
        },
        "timeout_queue_test": {"srcs": ["TimeoutQueueTest.cpp"]},
        "token_bucket_test": {"srcs": ["TokenBucketTest.cpp"]},
        "traits_test": {"srcs": ["TraitsTest.cpp"]},
        "try_test": {"srcs": ["TryTest.cpp"], "tags": ["WINDOWS_DISABLED"]},
        "unit_test": {"srcs": ["UnitTest.cpp"]},
        "uri_benchmark": {"benchmark": 1, "srcs": ["UriBenchmark.cpp"]},
        "uri_test": {"srcs": ["UriTest.cpp"]},
        "varint_test": {"srcs": ["VarintTest.cpp"]},
    },
}

_folly_cmake_patch = {
    "container/test/": {
        # TODO(pkomlev): understand why the build is broken.
        "f14_map_test": {"tags": ["BROKEN"]},
    },
    "concurrency/test/": {
        "atomic_shared_ptr_test": {
            "hdrs": ["AtomicSharedPtrCounted.h"],
        },
    },
    "experimental/crypto/test/": {
        # TODO(pkomlev): make conditional, on libsodium available.
        "blake2xb_test": {"tags": ["BROKEN"]},
        "lt_hash_test": {"tags": ["BROKEN"]},
    },
    "experimental/io/test/": {
        # TODO(pkomlev): make conditional, on asyncio available.
        "fs_util_test": {"tags": ["BROKEN"]},
        "async_io_test": {"tags": ["BROKEN"]},
    },
    "gen/test/": {
        # TODO(pkomlev): missing header decl in folly CMakeFile.txt
        "parallel_benchmark": {"hdrs": ["Bench.h"]},
    },
    "io/async/test/": {
        # TODO(pkomlev): missing header decl in folly CMakeFile.txt
        "ssl_session_test": {"hdrs": ["AsyncSSLSocketTest.h"]},
    },
    "synchronization/test/": {
        # TODO(pkomlev): missing header decl in folly CMakeFile.txt
        "baton_benchmark": {"hdrs": ["BatonTestHelpers.h"]},
        # TODO(pkomlev): missing header decl in folly CMakeFile.txt
        "baton_test": {"hdrs": ["BatonTestHelpers.h"]},
    },
    "test/": {
        # TODO(pkomlev): missing header decl in folly CMakeFile.txt
        "dynamic_test": {"hdrs": ["ComparisonOperatorTestUtil.h"]},
        # TODO(pkomlev): missing header decl in folly CMakeFile.txt
        "fbvector_test": {"hdrs": ["FBVectorTests.cpp.h"]},
        # TODO(pkomlev): missing header decl in folly CMakeFile.txt
        "synchronized_test": {"hdrs": ["SynchronizedTestLib.h", "SynchronizedTestLib-inl.h"]},
        # TODO(pkomlev): missing header decl in folly CMakeFile.txt
        "token_bucket_test": {"hdrs": ["TokenBucketTest.h"]},
    },
}
