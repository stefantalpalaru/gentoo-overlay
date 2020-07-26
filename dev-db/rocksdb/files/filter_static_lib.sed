s/_expectedTarget RocksDB::rocksdb /_expectedTarget /g
/# Create imported target RocksDB::rocksdb\$/d
/# Import target \"RocksDB::rocksdb\"/d
/add_library(RocksDB::rocksdb /d
/set_property(TARGET RocksDB::rocksdb /d
/list(APPEND _IMPORT_CHECK_TARGETS RocksDB::rocksdb )/d
/list(APPEND _IMPORT_CHECK_FILES_FOR_RocksDB::rocksdb /d
