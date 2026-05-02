# Amazon Athena Performance Improvement

## Data Format Optimization

### Use Columnar Data Formats

- Use columnar data formats for cost-savings (reduces data scanning)
- Recommended formats:
  - Apache Parquet
  - ORC (Optimized Row Columnar)
- These formats provide significant performance improvements
- Use AWS Glue to convert existing data to Parquet or ORC

### Compression

- Implement data compression for smaller retrievals
- Supported compression formats:
  - bzip2
  - gzip
  - lz4
  - snappy
  - zlib
  - zstd

## Data Organization

### Partitioning

- Partition datasets in S3 for efficient querying using virtual columns
- Partition structure:
