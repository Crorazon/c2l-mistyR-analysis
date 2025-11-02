# Results Directory

This directory contains all analysis outputs from the Cell2location-MistyR pipeline.

## Structure

```
results/
├── cell2location/     # Cell2location deconvolution results
├── mistyR/           # MistyR spatial interaction results
├── figures/          # Generated plots and visualizations
├── reports/          # Analysis reports (HTML, PDF)
├── statistics/       # Statistical analysis outputs
└── cache/           # Cached intermediate results
```

## Output Files

### Cell2location Results
- `cell_abundance_w_sf.csv` - Cell type abundances
- `means_cell_abundance_w_sf.csv` - Mean abundances
- `stds_cell_abundance_w_sf.csv` - Standard deviations
- `q05_cell_abundance_w_sf.csv` - 5th percentiles
- `q95_cell_abundance_w_sf.csv` - 95th percentiles

### MistyR Results
- `importances.txt` - Feature importance scores
- `interactions.txt` - Cell-cell interaction predictions
- `performance.txt` - Model performance metrics
- `contributions.txt` - View-specific contributions

### Visualizations
- `interaction_heatmap.pdf` - Cell interaction heatmaps
- `spatial_plots.pdf` - Spatial distribution plots
- `network_diagrams.pdf` - Interaction network graphs
- `summary_statistics.pdf` - Statistical summary plots

## File Management

- Results are organized by analysis date and sample ID
- Large result files are compressed automatically
- Intermediate files are stored in `cache/` subdirectory
- Final publication-ready figures are in `figures/publication/`