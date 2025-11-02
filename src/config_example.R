# =============================================================================
# Cell2location-MistyR-MCP 配置示例文件
# =============================================================================
# 本文件展示了如何配置MistyR多样本空间细胞共定位分析的各种参数
# 复制此文件并根据您的项目需求进行修改

# =============================================================================
# 1. 项目基础配置
# =============================================================================

# 项目名称（用于输出文件命名）
PROJECT_NAME <- "HNSCC_Spatial_Analysis"

# 数据路径配置
DATA_PATH <- "/path/to/your/spatial/data"           # 空间转录组数据路径
REFERENCE_PATH <- "/path/to/single/cell/reference"  # 单细胞参考数据路径
OUTPUT_PATH <- "/path/to/output/results"            # 结果输出路径

# 创建输出目录结构
OUTPUT_DIRS <- list(
  main = OUTPUT_PATH,
  mistyR = file.path(OUTPUT_PATH, "mistyR_results"),
  plots = file.path(OUTPUT_PATH, "plots"),
  tables = file.path(OUTPUT_PATH, "tables"),
  reports = file.path(OUTPUT_PATH, "reports")
)

# =============================================================================
# 2. 空间视图参数配置
# =============================================================================

# MistyR空间视图定义
SPATIAL_VIEWS <- list(
  # 细胞内视图：基于基因表达的内在特征
  intra = "intra",
  
  # 近距离旁分泌视图：100微米范围内的细胞间相互作用
  para_100 = list(
    type = "para",
    l = 100,           # 距离阈值（微米）
    family = "gaussian" # 权重函数类型
  ),
  
  # 中距离旁分泌视图：200微米范围内的细胞间相互作用
  para_200 = list(
    type = "para",
    l = 200,
    family = "gaussian"
  )
)

# 空间权重函数参数
SPATIAL_WEIGHTS <- list(
  # 高斯权重函数的标准差参数
  sigma_100 = 50,   # 100μm视图的sigma值
  sigma_200 = 100   # 200μm视图的sigma值
)

# =============================================================================
# 3. 细胞类型过滤参数
# =============================================================================

# 细胞类型质量控制阈值
CELL_TYPE_FILTERS <- list(
  min_cells_per_type = 50,      # 每种细胞类型最少细胞数
  min_spots_per_sample = 100,   # 每个样本最少spot数
  min_abundance_threshold = 0.01, # 最小丰度阈值
  max_cell_types = 50           # 最大细胞类型数量
)

# 重点分析的细胞类型（根据您的研究重点修改）
FOCUS_CELL_TYPES <- c(
  "CD4_Treg_CTLA4",  # Treg细胞
  "Macro_Isg15",     # ISG15+巨噬细胞
  "Tumor_6",         # 肿瘤细胞亚型6
  "Tumor_9"          # 肿瘤细胞亚型9
)

# 细胞类型分组（用于分层分析）
CELL_TYPE_GROUPS <- list(
  immune = c("CD4_Treg_CTLA4", "CD8_T", "NK", "B_cell"),
  myeloid = c("Macro_Isg15", "Macro_M1", "Macro_M2", "DC"),
  tumor = c("Tumor_6", "Tumor_9", "Tumor_1", "Tumor_2"),
  stromal = c("Fibroblast", "Endothelial", "Pericyte")
)

# =============================================================================
# 4. MistyR分析参数
# =============================================================================

# MistyR核心参数
MISTY_PARAMS <- list(
  seed = 42,                    # 随机种子，确保结果可重复
  n_cores = 8,                  # 并行计算核心数
  bypass_intra = FALSE,         # 是否跳过intra视图
  target_selection = "all",     # 目标基因选择策略
  sample_percentage = 100       # 使用的样本百分比
)

# 模型训练参数
MODEL_PARAMS <- list(
  # 随机森林参数
  ntree = 100,                  # 决策树数量
  mtry_ratio = 0.33,           # 每次分割考虑的特征比例
  nodesize = 5,                # 叶节点最小样本数
  
  # 交叉验证参数
  cv_folds = 10,               # 交叉验证折数
  importance_measure = "gain"   # 重要性度量方法
)

# =============================================================================
# 5. 统计分析参数
# =============================================================================

# 统计显著性阈值
STATISTICAL_THRESHOLDS <- list(
  importance_threshold = 0.5,   # 相互作用重要性阈值
  pvalue_threshold = 0.05,      # p值阈值
  fdr_threshold = 0.1,          # FDR阈值
  effect_size_threshold = 0.2   # 效应量阈值
)

# 多重比较校正方法
MULTIPLE_TESTING <- list(
  method = "BH",                # Benjamini-Hochberg方法
  alpha = 0.05                  # 显著性水平
)

# =============================================================================
# 6. 可视化参数
# =============================================================================

# 图表基础设置
PLOT_PARAMS <- list(
  # 图片格式和尺寸
  format = c("pdf", "png"),     # 输出格式
  width = 12,                   # 图片宽度（英寸）
  height = 10,                  # 图片高度（英寸）
  dpi = 300,                    # 分辨率
  
  # 字体设置
  base_size = 12,               # 基础字体大小
  title_size = 16,              # 标题字体大小
  axis_text_size = 10,          # 坐标轴文字大小
  
  # 颜色设置
  color_palette = "RdYlBu",     # 热图颜色方案
  discrete_colors = "Set3"      # 离散变量颜色方案
)

# 热图特定参数
HEATMAP_PARAMS <- list(
  clustering_method = "ward.D2", # 聚类方法
  distance_method = "euclidean", # 距离度量
  show_row_names = TRUE,         # 显示行名
  show_column_names = TRUE,      # 显示列名
  annotation_colors = list(),    # 注释颜色
  cell_border_color = "white"    # 单元格边框颜色
)

# 网络图参数
NETWORK_PARAMS <- list(
  layout = "fruchterman.reingold", # 网络布局算法
  node_size_range = c(3, 15),      # 节点大小范围
  edge_width_range = c(0.5, 5),    # 边宽度范围
  alpha_threshold = 0.6,           # 边透明度阈值
  label_size = 3                   # 标签字体大小
)

# =============================================================================
# 7. 报告生成参数
# =============================================================================

# 报告配置
REPORT_PARAMS <- list(
  generate_html = TRUE,         # 生成HTML报告
  generate_pdf = FALSE,         # 生成PDF报告
  include_code = FALSE,         # 是否包含代码
  include_warnings = FALSE,     # 是否包含警告信息
  
  # 报告内容控制
  include_qc_plots = TRUE,      # 包含质控图
  include_interaction_plots = TRUE, # 包含相互作用图
  include_statistical_tables = TRUE, # 包含统计表格
  include_interpretation = TRUE  # 包含结果解释
)

# =============================================================================
# 8. 高级分析参数
# =============================================================================

# 功能富集分析
ENRICHMENT_PARAMS <- list(
  perform_enrichment = TRUE,    # 是否进行富集分析
  databases = c("GO", "KEGG", "Reactome"), # 使用的数据库
  organism = "human",           # 物种
  pvalue_cutoff = 0.05,        # p值阈值
  qvalue_cutoff = 0.1          # q值阈值
)

# 时空动态分析（如果有时间序列数据）
TEMPORAL_PARAMS <- list(
  perform_temporal = FALSE,     # 是否进行时间序列分析
  time_points = NULL,           # 时间点
  trajectory_method = "monocle3" # 轨迹推断方法
)

# =============================================================================
# 9. 计算资源配置
# =============================================================================

# 并行计算设置
PARALLEL_PARAMS <- list(
  use_parallel = TRUE,          # 是否使用并行计算
  n_cores = min(8, parallel::detectCores() - 1), # 使用的核心数
  memory_limit = "16GB",        # 内存限制
  temp_dir = tempdir()          # 临时文件目录
)

# 缓存设置
CACHE_PARAMS <- list(
  use_cache = TRUE,             # 是否使用缓存
  cache_dir = file.path(OUTPUT_PATH, "cache"), # 缓存目录
  cache_intermediate = TRUE,    # 缓存中间结果
  clear_cache = FALSE          # 是否清空现有缓存
)

# =============================================================================
# 10. 验证和调试参数
# =============================================================================

# 调试模式
DEBUG_PARAMS <- list(
  verbose = TRUE,               # 详细输出
  save_intermediate = TRUE,     # 保存中间结果
  log_file = file.path(OUTPUT_PATH, "analysis.log"), # 日志文件
  error_handling = "stop"       # 错误处理方式："stop", "warn", "ignore"
)

# 结果验证
VALIDATION_PARAMS <- list(
  run_validation = TRUE,        # 是否运行验证
  validation_samples = 0.2,     # 验证样本比例
  cross_validation = TRUE,      # 是否进行交叉验证
  bootstrap_n = 1000           # Bootstrap重采样次数
)

# =============================================================================
# 配置验证函数
# =============================================================================

validate_config <- function() {
  # 检查必需的路径是否存在
  if (!dir.exists(dirname(DATA_PATH))) {
    stop("数据路径不存在: ", DATA_PATH)
  }
  
  # 检查输出路径是否可写
  if (!dir.exists(OUTPUT_PATH)) {
    dir.create(OUTPUT_PATH, recursive = TRUE)
  }
  
  # 检查重点细胞类型是否为空
  if (length(FOCUS_CELL_TYPES) == 0) {
    warning("未指定重点分析的细胞类型")
  }
  
  # 检查并行核心数是否合理
  if (PARALLEL_PARAMS$n_cores > parallel::detectCores()) {
    warning("指定的核心数超过系统可用核心数")
  }
  
  cat("配置验证完成！\n")
}

# 运行配置验证
# validate_config()

# =============================================================================
# 使用说明
# =============================================================================

# 1. 复制此文件到您的项目目录
# 2. 根据您的数据和分析需求修改相应参数
# 3. 在主分析脚本中加载此配置文件：source("config_example.R")
# 4. 运行分析：run_mistyR_analysis()

cat("配置文件加载完成！\n")
cat("项目名称:", PROJECT_NAME, "\n")
cat("重点分析细胞类型:", paste(FOCUS_CELL_TYPES, collapse = ", "), "\n")