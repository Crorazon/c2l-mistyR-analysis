# =============================================================================
# MistyR多样本空间细胞共定位分析流程 - 通用模板
# =============================================================================
# 基于"单细胞空间交响乐"公众号方法
# 适用于任何空间转录组数据的细胞类型共定位分析
# 
# 作者: [Your Name]
# 创建日期: 2024-01-XX
# 版本: v1.0
# =============================================================================

# =============================================================================
# 1. 环境配置
# =============================================================================

# 清理环境
rm(list = ls())
gc()

# 加载必需的R包
required_packages <- c(
  "Seurat", "SeuratObject", "mistyR", "future", "future.apply",
  "dplyr", "ggplot2", "ComplexHeatmap", "circlize", "RColorBrewer",
  "pheatmap", "corrplot", "igraph", "networkD3", "plotly",
  "DT", "knitr", "rmarkdown", "readr", "stringr", "tidyr"
)

# 检查并安装缺失的包
missing_packages <- setdiff(required_packages, rownames(installed.packages()))
if(length(missing_packages) > 0) {
  install.packages(missing_packages)
}

# 加载所有包
lapply(required_packages, library, character.only = TRUE)

# 设置并行计算
plan(multisession, workers = 8)

# =============================================================================
# 2. 项目配置参数 (用户需要修改的部分)
# =============================================================================

# 项目基本信息
PROJECT_CONFIG <- list(
  # 项目名称
  project_name = "Spatial_Colocalization_Analysis",
  
  # 路径配置
  data_path = "/path/to/your/spatial/data",
  reference_path = "/path/to/single/cell/reference", 
  output_path = "/path/to/output/results",
  
  # 数据类型
  data_type = "Visium",  # 或 "ST", "Slide-seq" 等
  species = "human"      # 或 "mouse"
)

# 空间视图参数
SPATIAL_VIEWS <- list(
  intra = "intra",
  para_100 = list(type = "para", l = 100),
  para_200 = list(type = "para", l = 200)
)

# 细胞类型过滤参数
CELL_FILTERS <- list(
  min_cells_per_type = 50,
  min_spots_per_sample = 100,
  min_abundance = 0.01
)

# MistyR参数
MISTY_PARAMS <- list(
  seed = 42,
  n_cores = 8,
  target_selection = "all"
)

# 可视化参数
VIS_PARAMS <- list(
  width = 12,
  height = 10,
  dpi = 300,
  format = c("pdf", "png")
)

# 重点分析的细胞类型 (根据研究目标修改)
FOCUS_CELL_TYPES <- c(
  "CD4_Treg_CTLA4",  # 示例：根据实际数据修改
  "Macro_Isg15",
  "Tumor_6", 
  "Tumor_9"
)

# =============================================================================
# 3. 核心函数定义
# =============================================================================

#' 从 Seurat对象提取MistyR所需数据
#' @param seurat_obj Seurat对象
#' @param cell_types 细胞类型列名
#' @return 格式化的数据框
extract_seurat_data <- function(seurat_obj, cell_types = "cell_type") {
  
  # 提取空间坐标
  spatial_coords <- GetTissueCoordinates(seurat_obj)
  
  # 提取细胞类型丰度数据
  if(cell_types %in% colnames(seurat_obj@meta.data)) {
    # 如果是分类变量，转换为丰度矩阵
    cell_abundance <- model.matrix(~ . - 1, 
                                   data = seurat_obj@meta.data[cell_types])
  } else {
    # 如果已经是丰度数据
    cell_abundance <- seurat_obj@assays$predictions@data
  }
  
  # 合并数据
  misty_data <- cbind(spatial_coords, t(cell_abundance))
  
  return(misty_data)
}

#' 运行单样本MistyR分析
#' @param sample_data 样本数据
#' @param sample_name 样本名称
#' @param output_dir 输出目录
run_single_sample_mistyR <- function(sample_data, sample_name, output_dir) {
  
  cat("Processing sample:", sample_name, "\n")
  
  # 创建样本输出目录
  sample_dir <- file.path(output_dir, sample_name)
  dir.create(sample_dir, recursive = TRUE, showWarnings = FALSE)
  
  # 准备MistyR数据
  misty_views <- create_initial_view(sample_data %>% select(-row, -col)) %>%
    add_paraview(sample_data, l = SPATIAL_VIEWS$para_100$l, family = "gaussian") %>%
    add_paraview(sample_data, l = SPATIAL_VIEWS$para_200$l, family = "gaussian")
  
  # 运行MistyR
  run_misty(misty_views, 
           results.folder = sample_dir,
           seed = MISTY_PARAMS$seed)
  
  cat("Completed sample:", sample_name, "\n")
  return(sample_dir)
}

#' 批量处理多个样本
#' @param data_path 数据路径
#' @param output_path 输出路径
batch_process_samples <- function(data_path, output_path) {
  
  # 获取所有样本文件
  sample_files <- list.files(data_path, pattern = "\\.rds$|\\.h5$", full.names = TRUE)
  
  # 创建输出目录
  dir.create(output_path, recursive = TRUE, showWarnings = FALSE)
  
  # 并行处理样本
  sample_results <- future_map(sample_files, function(file) {
    
    sample_name <- tools::file_path_sans_ext(basename(file))
    
    # 加载数据
    if(grepl("\\.rds$", file)) {
      seurat_obj <- readRDS(file)
    } else if(grepl("\\.h5$", file)) {
      seurat_obj <- LoadH5Seurat(file)
    }
    
    # 提取MistyR数据
    sample_data <- extract_seurat_data(seurat_obj)
    
    # 运行MistyR分析
    result_dir <- run_single_sample_mistyR(sample_data, sample_name, output_path)
    
    return(list(sample = sample_name, result_dir = result_dir))
  })
  
  return(sample_results)
}

#' 收集和整合多样本结果
#' @param results_dirs 结果目录列表
#' @param output_path 输出路径
collect_multisample_results <- function(results_dirs, output_path) {
  
  cat("Collecting results from", length(results_dirs), "samples\n")
  
  # 收集所有样本的结果
  collect_results(results_dirs, "multisample_results")
  
  # 生成多样本报告
  misty_results <- collect_results(results_dirs)
  
  # 保存整合结果
  saveRDS(misty_results, file.path(output_path, "integrated_mistyR_results.rds"))
  
  return(misty_results)
}

#' 生成标准化图表
#' @param misty_results MistyR结果
#' @param focus_types 重点细胞类型
#' @param output_path 输出路径
generate_standard_plots <- function(misty_results, focus_types, output_path) {
  
  # 1. 相互作用热图
  plot_interaction_heatmap(misty_results, focus_types, output_path)
  
  # 2. 重要性分布图
  plot_importance_distribution(misty_results, focus_types, output_path)
  
  # 3. 网络图
  plot_interaction_network(misty_results, focus_types, output_path)
  
  # 4. 样本一致性分析
  plot_sample_consistency(misty_results, focus_types, output_path)
  
  cat("All standard plots generated successfully!\n")
}

# =============================================================================
# 4. 主分析流程
# =============================================================================

#' 主分析函数
#' @param config 项目配置
run_mistyR_analysis <- function(config = PROJECT_CONFIG) {
  
  cat("=== MistyR多样本空间细胞共定位分析流程 ===\n")
  cat("项目名称:", config$project_name, "\n")
  cat("数据路径:", config$data_path, "\n")
  cat("输出路径:", config$output_path, "\n\n")
  
  # 步骤1: 批量处理样本
  cat("步骤1: 批量处理样本...\n")
  sample_results <- batch_process_samples(config$data_path, config$output_path)
  
  # 步骤2: 收集多样本结果
  cat("步骤2: 收集多样本结果...\n")
  results_dirs <- sapply(sample_results, function(x) x$result_dir)
  integrated_results <- collect_multisample_results(results_dirs, config$output_path)
  
  # 步骤3: 生成标准化图表
  cat("步骤3: 生成标准化图表...\n")
  generate_standard_plots(integrated_results, FOCUS_CELL_TYPES, config$output_path)
  
  # 步骤4: 生成分析报告
  cat("步骤4: 生成分析报告...\n")
  generate_analysis_report(integrated_results, config)
  
  cat("=== 分析完成! ===\n")
  cat("结果保存在:", config$output_path, "\n")
  
  return(integrated_results)
}

# =============================================================================
# 5. 分析报告生成
# =============================================================================

#' 生成分析报告
generate_analysis_report <- function(results, config) {
  
  report_template <- '
---
title: "MistyR多样本空间细胞共定位分析报告"
author: "Generated by MistyR Universal Template"
date: "`r Sys.Date()`"
output: 
  html_document:
    toc: true
    toc_float: true
    theme: flatly
---

# 项目概述

- **项目名称**: `r config$project_name`
- **数据类型**: `r config$data_type`
- **物种**: `r config$species`
- **分析日期**: `r Sys.Date()`

# 分析方法

本分析基于"单细胞空间交响乐"公众号的MistyR多样本空间细胞共定位分析流程，包含以下核心步骤：

1. **多样本批量处理**: 同时分析多个空间转录组样本
2. **多视图空间建模**: Intra-cellular + Paracrine (100μm & 200μm)
3. **统计整合分析**: 跨样本统计分析和重要性评估
4. **可视化输出**: 热图、网络图、统计图表

# 重点细胞类型分析

重点分析的细胞类型：`r paste(FOCUS_CELL_TYPES, collapse = ", ")`

# 结果解释

## 相互作用重要性评分
- 范围: 0-1，越高表示相互作用越重要
- 阈值: >0.5 被认为是显著相互作用

## 空间共定位模式
- 正相关: 细胞类型倾向于空间聚集
- 负相关: 细胞类型倾向于空间分离

# 技术参数

- **空间视图**: `r paste(names(SPATIAL_VIEWS), collapse = ", ")`
- **随机种子**: `r MISTY_PARAMS$seed`
- **并行核心数**: `r MISTY_PARAMS$n_cores`
'
  
  # 写入报告模板
  report_file <- file.path(config$output_path, "analysis_report.Rmd")
  writeLines(report_template, report_file)
  
  # 渲染报告
  rmarkdown::render(report_file, 
                   output_file = "MistyR_Analysis_Report.html",
                   output_dir = config$output_path)
}

# =============================================================================
# 6. 使用说明和示例
# =============================================================================

# 使用示例:
# 
# 1. 修改PROJECT_CONFIG中的路径和参数
# 2. 修改FOCUS_CELL_TYPES为您关注的细胞类型
# 3. 运行分析:
#    results <- run_mistyR_analysis()
#
# 4. 查看结果:
#    - 图表: output_path/plots/
#    - 数据: output_path/tables/
#    - 报告: output_path/MistyR_Analysis_Report.html

# =============================================================================
# 7. 模板保存和版本控制
# =============================================================================

# 保存当前配置
save_template_config <- function(config_name = "default") {
  config_list <- list(
    PROJECT_CONFIG = PROJECT_CONFIG,
    SPATIAL_VIEWS = SPATIAL_VIEWS,
    CELL_FILTERS = CELL_FILTERS,
    MISTY_PARAMS = MISTY_PARAMS,
    VIS_PARAMS = VIS_PARAMS,
    FOCUS_CELL_TYPES = FOCUS_CELL_TYPES
  )
  
  config_file <- paste0("mistyR_config_", config_name, ".rds")
  saveRDS(config_list, config_file)
  cat("配置已保存:", config_file, "\n")
}

# 加载配置
load_template_config <- function(config_file) {
  config_list <- readRDS(config_file)
  list2env(config_list, envir = .GlobalEnv)
  cat("配置已加载:", config_file, "\n")
}

# 版本信息
TEMPLATE_VERSION <- list(
  version = "1.0.0",
  date = Sys.Date(),
  description = "MistyR多样本空间细胞共定位分析通用模板",
  based_on = "单细胞空间交响乐公众号方法"
)

cat("=== MistyR Universal Template Loaded ===\n")
cat("版本:", TEMPLATE_VERSION$version, "\n")
cat("基于:", TEMPLATE_VERSION$based_on, "\n")
cat("使用方法: run_mistyR_analysis()\n")
cat("========================================\n")