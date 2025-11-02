# Scripts Directory

Utility scripts and helper functions for the Cell2location-MistyR analysis pipeline.

## Structure

```
scripts/
├── preprocessing/    # Data preprocessing scripts
├── analysis/        # Analysis workflow scripts
├── visualization/   # Plotting and visualization scripts
├── utilities/       # General utility functions
└── validation/      # Quality control and validation scripts
```

## Script Categories

### Preprocessing Scripts
- `prepare_spatial_data.R` - Spatial data preprocessing
- `prepare_reference_data.R` - Reference data preparation
- `quality_control.R` - Data quality assessment
- `normalization.R` - Data normalization procedures

### Analysis Scripts
- `run_cell2location.py` - Cell2location analysis wrapper
- `run_mistyR_analysis.R` - MistyR analysis execution
- `batch_processing.R` - Multi-sample batch analysis
- `statistical_analysis.R` - Statistical testing and validation

### Visualization Scripts
- `plot_spatial_maps.R` - Spatial visualization functions
- `plot_interactions.R` - Interaction plotting functions
- `generate_reports.R` - Automated report generation
- `create_figures.R` - Publication-ready figure creation

### Utility Scripts
- `file_management.R` - File I/O utilities
- `parameter_validation.R` - Configuration validation
- `logging_functions.R` - Logging and progress tracking
- `parallel_processing.R` - Parallel computation utilities

## Usage Guidelines

- All scripts should be well-documented with roxygen2 comments
- Include parameter validation and error handling
- Use consistent coding style and naming conventions
- Test scripts with sample data before production use
- Maintain version control for script modifications