# Data Directory

This directory contains input data for the Cell2location-MistyR analysis.

## Structure

```
data/
├── spatial/          # Spatial transcriptomics data (Visium, ST, etc.)
├── reference/        # Single-cell reference data
├── annotations/      # Cell type annotations and metadata
└── processed/        # Processed and intermediate data files
```

## Data Requirements

### Spatial Transcriptomics Data
- **Format**: 10X Genomics Visium, Spatial Transcriptomics, or similar
- **Files**: 
  - `filtered_feature_bc_matrix/` (count matrix)
  - `spatial/` (spatial coordinates and images)
  - `metadata.csv` (sample information)

### Single-cell Reference Data
- **Format**: h5ad, h5seurat, or RDS
- **Requirements**: 
  - Cell type annotations
  - Quality control metrics
  - Normalized expression data

## Usage Notes

- Large data files are excluded from git tracking (see `.gitignore`)
- Use symbolic links for shared datasets
- Document data sources and preprocessing steps
- Maintain consistent file naming conventions