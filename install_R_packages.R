# =============================================================================
# c2l-mistyR项目 R环境依赖安装脚本
# =============================================================================
# 本脚本将自动安装MistyR多样本空间细胞共定位分析所需的所有R包
# 运行方法: source("install_R_packages.R")

# 设置CRAN镜像
options(repos = c(CRAN = "https://cran.rstudio.com/"))

# 检查并安装包的函数
install_if_missing <- function(packages, source = "CRAN") {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      cat("Installing", pkg, "from", source, "...\n")
      
      if (source == "CRAN") {
        install.packages(pkg, dependencies = TRUE)
      } else if (source == "Bioconductor") {
        if (!requireNamespace("BiocManager", quietly = TRUE)) {
          install.packages("BiocManager")
        }
        BiocManager::install(pkg, dependencies = TRUE)
      } else if (source == "GitHub") {
        if (!requireNamespace("devtools", quietly = TRUE)) {
          install.packages("devtools")
        }
        devtools::install_github(pkg)
      }
      
      # 验证安装
      if (require(pkg, character.only = TRUE, quietly = TRUE)) {
        cat("✓", pkg, "installed successfully\n")
      } else {
        cat("✗ Failed to install", pkg, "\n")
      }
    } else {
      cat("✓", pkg, "already installed\n")
    }
  }
}

# =============================================================================
# 核心依赖包
# =============================================================================
cat("=== Installing Core Dependencies ===\n")
core_packages <- c(
  "devtools",
  "BiocManager",
  "remotes",
  "pak"
)
install_if_missing(core_packages, "CRAN")

# =============================================================================
# 数据处理包
# =============================================================================
cat("\n=== Installing Data Processing Packages ===\n")
data_packages <- c(
  "dplyr",
  "tidyr",
  "readr",
  "stringr",
  "purrr",
  "tibble",
  "magrittr",
  "data.table",
  "Matrix",
  "matrixStats"
)
install_if_missing(data_packages, "CRAN")

# =============================================================================
# 单细胞分析包
# =============================================================================
cat("\n=== Installing Single Cell Analysis Packages ===\n")
sc_packages_cran <- c(
  "Seurat",
  "SeuratObject",
  "future",
  "future.apply",
  "progressr"
)
install_if_missing(sc_packages_cran, "CRAN")

# Bioconductor单细胞包
sc_packages_bioc <- c(
  "SingleCellExperiment",
  "SummarizedExperiment",
  "scater",
  "scran",
  "BiocGenerics",
  "S4Vectors",
  "IRanges",
  "GenomicRanges"
)
install_if_missing(sc_packages_bioc, "Bioconductor")

# =============================================================================
# MistyR和空间分析包
# =============================================================================
cat("\n=== Installing MistyR and Spatial Analysis Packages ===\n")
spatial_packages <- c(
  "mistyR",
  "future",
  "distances",
  "FNN",
  "dbscan",
  "sp",
  "sf",
  "raster",
  "rgeos",
  "maptools"
)
install_if_missing(spatial_packages, "CRAN")

# =============================================================================
# 统计分析和机器学习包
# =============================================================================
cat("\n=== Installing Statistical and ML Packages ===\n")
stats_packages <- c(
  "randomForest",
  "caret",
  "glmnet",
  "e1071",
  "cluster",
  "factoextra",
  "FactoMineR",
  "corrplot",
  "Hmisc",
  "psych"
)
install_if_missing(stats_packages, "CRAN")

# =============================================================================
# 可视化包
# =============================================================================
cat("\n=== Installing Visualization Packages ===\n")
vis_packages <- c(
  "ggplot2",
  "ggpubr",
  "ggrepel",
  "ggsci",
  "RColorBrewer",
  "viridis",
  "scales",
  "gridExtra",
  "cowplot",
  "patchwork",
  "pheatmap",
  "ComplexHeatmap",
  "circlize",
  "VennDiagram",
  "UpSetR"
)
install_if_missing(vis_packages, "CRAN")

# Bioconductor可视化包
vis_packages_bioc <- c(
  "ComplexHeatmap",
  "EnhancedVolcano"
)
install_if_missing(vis_packages_bioc, "Bioconductor")

# =============================================================================
# 网络分析包
# =============================================================================
cat("\n=== Installing Network Analysis Packages ===\n")
network_packages <- c(
  "igraph",
  "network",
  "sna",
  "ggraph",
  "tidygraph",
  "networkD3",
  "visNetwork"
)
install_if_missing(network_packages, "CRAN")

# =============================================================================
# 报告生成包
# =============================================================================
cat("\n=== Installing Report Generation Packages ===\n")
report_packages <- c(
  "rmarkdown",
  "knitr",
  "DT",
  "plotly",
  "htmlwidgets",
  "flexdashboard",
  "bookdown",
  "tinytex"
)
install_if_missing(report_packages, "CRAN")

# =============================================================================
# 可选的Python接口包
# =============================================================================
cat("\n=== Installing Optional Python Interface Packages ===\n")
python_packages <- c(
  "reticulate",
  "basilisk",
  "zellkonverter"
)
install_if_missing(python_packages, "CRAN")

# =============================================================================
# 安装验证
# =============================================================================
cat("\n=== Verifying Installation ===\n")

# 检查关键包是否成功安装
key_packages <- c(
  "Seurat", "mistyR", "dplyr", "ggplot2", 
  "ComplexHeatmap", "future", "igraph"
)

installation_status <- sapply(key_packages, function(pkg) {
  requireNamespace(pkg, quietly = TRUE)
})

cat("\nInstallation Summary:\n")
for (i in seq_along(installation_status)) {
  status <- if (installation_status[i]) "✓ OK" else "✗ FAILED"
  cat(sprintf("%-20s: %s\n", names(installation_status)[i], status))
}

# 保存环境信息
cat("\n=== Saving Environment Information ===\n")
env_info <- list(
  R_version = R.version.string,
  platform = R.version$platform,
  install_date = Sys.Date(),
  installed_packages = installed.packages()[, c("Package", "Version")]
)

saveRDS(env_info, "R_environment_info.rds")
cat("Environment information saved to R_environment_info.rds\n")

# 输出完成信息
cat("\n" + paste(rep("=", 60), collapse = "") + "\n")
cat("🎉 R Package Installation Complete! 🎉\n")
cat(paste(rep("=", 60), collapse = "") + "\n")
cat("\nNext steps:\n")
cat("1. Load the MistyR template: source('src/MistyR_Universal_Template.R')\n")
cat("2. Configure your analysis: source('src/config_example.R')\n")
cat("3. Run your analysis: run_mistyR_analysis()\n")
cat("\nFor help and documentation, visit: https://github.com/Crorazon/c2l-mistyR-analysis\n")