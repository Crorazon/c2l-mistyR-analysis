# Tests Directory

Unit tests and integration tests for the Cell2location-MistyR analysis pipeline.

## Structure

```
tests/
├── unit/            # Unit tests for individual functions
├── integration/     # Integration tests for complete workflows
├── data/           # Test data and fixtures
├── benchmarks/     # Performance benchmarking tests
└── validation/     # Validation tests with known datasets
```

## Testing Framework

### R Tests (testthat)
- Unit tests for R functions and modules
- Integration tests for complete R workflows
- Performance benchmarks for computational functions

### Python Tests (pytest)
- Unit tests for Python components
- Integration tests for Cell2location workflows
- Data validation and format checking

## Test Categories

### Unit Tests
- `test_data_loading.R` - Data loading function tests
- `test_preprocessing.R` - Preprocessing function tests
- `test_mistyR_functions.R` - MistyR analysis function tests
- `test_visualization.R` - Plotting function tests
- `test_utilities.R` - Utility function tests

### Integration Tests
- `test_full_pipeline.R` - Complete pipeline testing
- `test_multi_sample.R` - Multi-sample analysis testing
- `test_parameter_combinations.R` - Parameter sensitivity testing

### Validation Tests
- `test_known_datasets.R` - Tests with validated datasets
- `test_reproducibility.R` - Reproducibility validation
- `test_cross_platform.R` - Cross-platform compatibility

## Running Tests

### R Tests
```r
# Run all tests
testthat::test_dir("tests/")

# Run specific test file
testthat::test_file("tests/unit/test_data_loading.R")

# Run with coverage
covr::package_coverage()
```

### Python Tests
```bash
# Run all tests
pytest tests/

# Run specific test file
pytest tests/unit/test_cell2location.py

# Run with coverage
pytest --cov=src tests/
```

## Test Data

- Small synthetic datasets for unit testing
- Subset of real data for integration testing
- Benchmark datasets for performance testing
- All test data should be lightweight and version-controlled

## Continuous Integration

- Tests are automatically run on code commits
- Coverage reports are generated and tracked
- Performance benchmarks are monitored for regressions
- Cross-platform testing ensures compatibility