# =============================================================================
# c2l-mistyR R环境依赖安装脚本
# =============================================================================
# Cell2location + MistyR 多样本空间细胞共定位分析流程
# R环境依赖包安装脚本
# 
# 使用方法:
# source("install_R_packages.R")
# 
# 或在命令行运行:
# Rscript install_R_packages.R
# =============================================================================

cat("=== c2l-mistyR R环境配置 ===")
cat("开始安装R依赖包...")
cat("安装时间:", Sys.time(), "")

# 设置CRAN镜像
options(repos = c(CRAN = "https://cran.rstudio.com/"))

# 检查并安装包的函数
install_if_missing <- function(packages, source = "CRAN") {
  for (pkg in packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      cat("安装包:", pkg, "来源:", source, "")
      
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
        cat("✓ 成功安装:", pkg, "")
      } else {
        cat("✗ 安装失败:", pkg, "")
      }
    } else {
      cat("✓ 已安装:", pkg, "")
    }
  }
}

# =============================================================================
# 核心依赖包
# =============================================================================

cat("--- 安装核心依赖包 ---")
core_packages <- c(
  "devtools",      # 开发工具
  "BiocManager",   # Bioconductor管理器
  "remotes",       # 远程包安装
  "renv",          # 环境管理
  "here",          # 路径管理
  "config"         # 配置管理
)
install_if_missing(core_packages, "CRAN")

# =============================================================================
# 数据处理和操作
# =============================================================================

cat("--- 安装数据处理包 ---")
data_packages <- c(
  "dplyr",         # 数据操作
  "tidyr",         # 数据整理
  "purrr",         # 函数式编程
  "readr",         # 数据读取
  "stringr",       # 字符串处理
  "forcats",       # 因子处理
  "lubridate",     # 日期时间
  "data.table",    # 高效数据表
  "magrittr"       # 管道操作
)
install_if_missing(data_packages, "CRAN")

# =============================================================================
# 单细胞和空间转录组分析
# =============================================================================

cat("--- 安装单细胞分析包 ---")
sc_packages <- c(
  "Seurat",        # 单细胞分析核心
  "SeuratObject",  # Seurat对象
  "SingleCellExperiment",  # 单细胞实验对象
  "scater",        # 单细胞分析工具
  "scran",         # 单细胞标准化
  "scuttle"        # 单细胞工具
)
install_if_missing(sc_packages, "Bioconductor")

# =============================================================================
# MistyR和空间分析
# =============================================================================

cat("--- 安装MistyR和空间分析包 ---")
spatial_packages <- c(
  "mistyR",        # MistyR核心包
  "future",        # 并行计算
  "future.apply",  # 并行应用
  "distances",     # 距离计算
  "FNN",           # 最近邻
  "dbscan"         # 密度聚类
)

# MistyR从GitHub安装
if (!require("mistyR", quietly = TRUE)) {
  cat("从GitHub安装MistyR...")
  devtools::install_github("saezlab/mistyR")
}

install_if_missing(spatial_packages[-1], "CRAN")

# =============================================================================
# 统计分析和机器学习
# =============================================================================

cat("--- 安装统计分析包 ---")
stats_packages <- c(
  "randomForest",  # 随机森林
  "ranger",        # 快速随机森林
  "caret",         # 机器学习框架
  "glmnet",        # 正则化回归
  "MASS",          # 统计函数
  "car",           # 回归分析
  "broom",         # 统计结果整理
  "corrplot",      # 相关性图
  "Hmisc"          # 统计工具
)
install_if_missing(stats_packages, "CRAN")

# =============================================================================
# 可视化包
# =============================================================================

cat("--- 安装可视化包 ---")
viz_packages <- c(
  "ggplot2",       # 基础绘图
  "ggpubr",        # 发表级图表
  "ggrepel",       # 标签避让
  "ggsci",         # 科学配色
  "viridis",       # 颜色方案
  "RColorBrewer",  # 颜色调色板
  "scales",        # 图表缩放
  "gridExtra",     # 图表排列
  "cowplot",       # 图表组合
  "patchwork",     # 图表拼接
  "pheatmap",      # 热图
  "ComplexHeatmap", # 复杂热图
  "circlize",      # 圆形图
  "VennDiagram",   # 韦恩图
  "UpSetR"         # 集合图
)

# ComplexHeatmap从Bioconductor安装
install_if_missing("ComplexHeatmap", "Bioconductor")
install_if_missing(viz_packages[viz_packages != "ComplexHeatmap"], "CRAN")

# =============================================================================
# 网络分析
# =============================================================================

cat("--- 安装网络分析包 ---")
network_packages <- c(
  "igraph",        # 网络分析
  "tidygraph",     # 整洁网络
  "ggraph",        # 网络可视化
  "visNetwork",    # 交互式网络
  "networkD3"      # D3网络图
)
install_if_missing(network_packages, "CRAN")

# =============================================================================
# 报告生成
# =============================================================================

cat("--- 安装报告生成包 ---")
report_packages <- c(
  "rmarkdown",     # R Markdown
  "knitr",         # 动态报告
  "DT",            # 交互式表格
  "plotly",        # 交互式图表
  "htmlwidgets",   # HTML小部件
  "flexdashboard", # 仪表板
  "bookdown",      # 书籍格式
  "pagedown"       # 页面布局
)
install_if_missing(report_packages, "CRAN")

# =============================================================================
# 可选：Python接口
# =============================================================================

cat("--- 安装Python接口包 ---")
python_packages <- c(
  "reticulate",    # Python接口
  "basilisk",      # Python环境管理
  "zellkonverter"  # Python-R数据转换
)
install_if_missing("zellkonverter", "Bioconductor")
install_if_missing(python_packages[python_packages != "zellkonverter"], "CRAN")

# =============================================================================
# 验证安装
# =============================================================================

cat("=== 验证关键包安装 ===")
key_packages <- c("Seurat", "mistyR", "ggplot2", "dplyr", "ComplexHeatmap")

all_installed <- TRUE
for (pkg in key_packages) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("✓", pkg, "- 版本:", as.character(packageVersion(pkg)), "")
  } else {
    cat("✗", pkg, "- 未安装或加载失败")
    all_installed <- FALSE
  }
}

# =============================================================================
# 环境信息
# =============================================================================

cat("=== R环境信息 ===")
cat("R版本:", R.version.string, "")
cat("平台:", R.version$platform, "")
cat("安装完成时间:", Sys.time(), "")

if (all_installed) {
  cat("🎉 所有关键包安装成功！")
  cat("现在可以运行c2l-mistyR分析流程了。")
} else {
  cat("⚠️  部分包安装失败，请检查错误信息。")
}

# 保存会话信息
writeLines(capture.output(sessionInfo()), "R_session_info.txt")
cat("会话信息已保存到: R_session_info.txt")

cat("=== 安装脚本完成 ===")