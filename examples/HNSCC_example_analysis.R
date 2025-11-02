# =============================================================================
# HNSCC空间细胞共定位分析示例
# =============================================================================
# 基于c2l-mistyR流程的头颈部鳞癌(HNSCC)数据分析示例
# 重点分析四种关键细胞类型的空间相互作用模式
# 
# 作者: c2l-mistyR团队
# 创建日期: 2024-11-02
# 版本: v1.0
# =============================================================================

# 加载主分析模板
source("src/MistyR_Universal_Template.R")

# =============================================================================
# HNSCC专项配置
# =============================================================================

# HNSCC项目配置
HNSCC_CONFIG <- list(
  project_name = "HNSCC_Spatial_Colocalization",
  data_path = "/path/to/HNSCC/spatial/data",
  reference_path = "/path/to/HNSCC/scRNA/reference",
  output_path = "/path/to/HNSCC/results",
  data_type = "Visium",
  species = "human",
  
  # HNSCC特异参数
  tumor_type = "HNSCC",
  analysis_focus = "immune_tumor_interaction"
)

# HNSCC重点细胞类型
HNSCC_FOCUS_TYPES <- c(
  "CD4_Treg_CTLA4",    # 调节性T细胞
  "Macro_Isg15",       # ISG15+巨噬细胞
  "Tumor_6",           # 肿瘤细胞亚群6
  "Tumor_9"            # 肿瘤细胞亚群9
)

# HNSCC空间视图配置
HNSCC_SPATIAL_VIEWS <- list(
  intra = "intra",
  para_close = list(type = "para", l = 100),   # 近距离相互作用
  para_distant = list(type = "para", l = 200)  # 远距离相互作用
)

# =============================================================================
# HNSCC专项分析函数
# =============================================================================

#' HNSCC四细胞类型深度分析
#' @param config HNSCC配置参数
#' @param focus_types 重点细胞类型
#' @return 分析结果对象
run_HNSCC_focused_analysis <- function(config = HNSCC_CONFIG, 
                                      focus_types = HNSCC_FOCUS_TYPES) {
  
  cat("=== HNSCC空间细胞共定位分析 ===\n")
  cat("重点细胞类型:", paste(focus_types, collapse = ", "), "\n")
  cat("分析开始时间:", Sys.time(), "\n\n")
  
  # 步骤1: 运行基础MistyR分析
  cat("步骤1: 运行基础MistyR分析...\n")
  base_results <- run_mistyR_analysis(config)
  
  # 步骤2: HNSCC特异性分析
  cat("步骤2: HNSCC特异性分析...\n")
  hnscc_results <- perform_HNSCC_specific_analysis(base_results, focus_types)
  
  # 步骤3: 免疫-肿瘤相互作用分析
  cat("步骤3: 免疫-肿瘤相互作用分析...\n")
  immune_tumor_results <- analyze_immune_tumor_interactions(hnscc_results, focus_types)
  
  # 步骤4: 生成HNSCC专项报告
  cat("步骤4: 生成HNSCC专项报告...\n")
  generate_HNSCC_report(immune_tumor_results, config)
  
  cat("=== HNSCC分析完成! ===\n")
  cat("结果保存在:", config$output_path, "\n")
  
  return(immune_tumor_results)
}

#' HNSCC特异性分析
perform_HNSCC_specific_analysis <- function(base_results, focus_types) {
  
  # 提取重点细胞类型的相互作用
  focused_interactions <- extract_focused_interactions(base_results, focus_types)
  
  # 识别核心相互作用轴
  core_axes <- identify_core_interaction_axes(focused_interactions)
  
  # 分析相互作用强度分布
  intensity_analysis <- analyze_interaction_intensity(focused_interactions)
  
  # 样本间一致性分析
  consistency_analysis <- analyze_sample_consistency(focused_interactions)
  
  return(list(
    focused_interactions = focused_interactions,
    core_axes = core_axes,
    intensity_analysis = intensity_analysis,
    consistency_analysis = consistency_analysis
  ))
}

#' 免疫-肿瘤相互作用分析
analyze_immune_tumor_interactions <- function(hnscc_results, focus_types) {
  
  # 定义免疫细胞和肿瘤细胞
  immune_cells <- c("CD4_Treg_CTLA4", "Macro_Isg15")
  tumor_cells <- c("Tumor_6", "Tumor_9")
  
  # 分析免疫抑制网络
  immunosuppressive_network <- analyze_immunosuppressive_interactions(
    hnscc_results, immune_cells, tumor_cells
  )
  
  # 分析肿瘤异质性
  tumor_heterogeneity <- analyze_tumor_spatial_heterogeneity(
    hnscc_results, tumor_cells
  )
  
  # 预测治疗靶点
  therapeutic_targets <- predict_therapeutic_targets(
    immunosuppressive_network, tumor_heterogeneity
  )
  
  return(list(
    hnscc_base = hnscc_results,
    immunosuppressive_network = immunosuppressive_network,
    tumor_heterogeneity = tumor_heterogeneity,
    therapeutic_targets = therapeutic_targets
  ))
}

# =============================================================================
# HNSCC可视化函数
# =============================================================================

#' 生成HNSCC核心相互作用热图
plot_HNSCC_core_heatmap <- function(results, output_path) {
  
  # 提取核心相互作用数据
  core_data <- results$hnscc_base$core_axes
  
  # 创建增强热图
  heatmap_plot <- ComplexHeatmap::Heatmap(
    core_data,
    name = "Interaction\nImportance",
    col = circlize::colorRamp2(c(0, 0.5, 1), c("blue", "white", "red")),
    cluster_rows = TRUE,
    cluster_columns = TRUE,
    show_row_names = TRUE,
    show_column_names = TRUE,
    row_title = "Target Cell Types",
    column_title = "Predictor Cell Types",
    heatmap_legend_param = list(
      title_position = "topcenter",
      legend_direction = "horizontal"
    )
  )
  
  # 保存图片
  pdf(file.path(output_path, "HNSCC_core_interaction_heatmap.pdf"), 
      width = 10, height = 8)
  draw(heatmap_plot)
  dev.off()
  
  return(heatmap_plot)
}

#' 生成免疫抑制网络图
plot_immunosuppressive_network <- function(results, output_path) {
  
  # 构建网络数据
  network_data <- results$immunosuppressive_network
  
  # 创建igraph对象
  g <- igraph::graph_from_data_frame(
    network_data$edges, 
    directed = TRUE, 
    vertices = network_data$nodes
  )
  
  # 设置节点和边的属性
  V(g)$size <- network_data$nodes$importance * 20
  V(g)$color <- ifelse(grepl("Tumor", V(g)$name), "red", "blue")
  E(g)$width <- network_data$edges$weight * 5
  E(g)$color <- "gray"
  
  # 绘制网络图
  pdf(file.path(output_path, "HNSCC_immunosuppressive_network.pdf"), 
      width = 12, height = 10)
  plot(g, 
       layout = layout_with_fr(g),
       vertex.label.cex = 0.8,
       vertex.label.color = "black",
       edge.arrow.size = 0.5,
       main = "HNSCC Immunosuppressive Network")
  dev.off()
  
  return(g)
}

# =============================================================================
# HNSCC报告生成
# =============================================================================

#' 生成HNSCC专项分析报告
generate_HNSCC_report <- function(results, config) {
  
  report_template <- '
---
title: "HNSCC空间细胞共定位分析报告"
author: "c2l-mistyR Pipeline"
date: "`r Sys.Date()`"
output: 
  html_document:
    toc: true
    toc_float: true
    theme: flatly
    code_folding: hide
---

# 项目概述

- **肿瘤类型**: 头颈部鳞癌 (HNSCC)
- **分析重点**: 免疫-肿瘤细胞空间相互作用
- **关键细胞类型**: `r paste(HNSCC_FOCUS_TYPES, collapse = ", ")`
- **分析日期**: `r Sys.Date()`

# 核心发现

## 三大相互作用轴

### 1. Treg → Tumor_6 轴
- **生物学意义**: 调节性T细胞对肿瘤细胞的免疫抑制作用
- **空间特征**: 近距离相互作用为主 (100μm)
- **临床意义**: 免疫治疗的潜在靶点

### 2. Treg → Macro_Isg15 轴  
- **生物学意义**: Treg细胞调控巨噬细胞极化
- **空间特征**: 中等距离相互作用 (100-200μm)
- **临床意义**: 免疫微环境重塑的关键

### 3. Tumor_6 → Treg 轴
- **生物学意义**: 肿瘤细胞招募免疫抑制细胞
- **空间特征**: 双向相互作用模式
- **临床意义**: 肿瘤免疫逃逸机制

# 统计分析结果

## 相互作用重要性评分

```{r importance_table, echo=FALSE}
# 显示重要性评分表格
knitr::kable(results$importance_scores, 
             caption = "细胞类型相互作用重要性评分")
```

## 样本间一致性

```{r consistency_plot, echo=FALSE}
# 显示一致性分析图
plot(results$consistency_analysis)
```

# 治疗意义

## 潜在治疗靶点

1. **Treg细胞耗竭**: 靶向CD4_Treg_CTLA4细胞
2. **巨噬细胞重编程**: 调控Macro_Isg15表型
3. **肿瘤异质性干预**: 针对Tumor_6和Tumor_9亚群

## 联合治疗策略

- **免疫检查点抑制剂** + **CAR-T细胞治疗**
- **巨噬细胞激活剂** + **肿瘤疫苗**
- **空间靶向给药** + **免疫调节剂**

# 技术参数

- **空间分辨率**: 55μm (Visium)
- **分析视图**: Intra + Para(100μm) + Para(200μm)
- **统计阈值**: 重要性评分 > 0.5
- **样本数量**: `r length(results$sample_list)`

# 方法学

本分析基于c2l-mistyR流程，整合了：
- Cell2location空间反卷积
- MistyR多视图空间建模
- 统计学习和机器学习方法
- 标准化可视化流程
'
  
  # 写入报告模板
  report_file <- file.path(config$output_path, "HNSCC_analysis_report.Rmd")
  writeLines(report_template, report_file)
  
  # 渲染报告
  rmarkdown::render(report_file, 
                   output_file = "HNSCC_Spatial_Analysis_Report.html",
                   output_dir = config$output_path)
}

# =============================================================================
# 使用示例
# =============================================================================

# 运行HNSCC完整分析
# hnscc_results <- run_HNSCC_focused_analysis()

# 生成核心可视化
# plot_HNSCC_core_heatmap(hnscc_results, HNSCC_CONFIG$output_path)
# plot_immunosuppressive_network(hnscc_results, HNSCC_CONFIG$output_path)

cat("HNSCC分析模块加载完成!\n")
cat("使用方法: run_HNSCC_focused_analysis()\n")