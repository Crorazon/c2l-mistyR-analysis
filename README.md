# Cell2location-MistyR-MCP: 多样本空间细胞共定位分析流程

## 项目简介

本项目基于"单细胞空间交响乐"公众号的MistyR分析方法，提供了一个完整的**MistyR多样本空间细胞共定位分析流程**。该流程整合了Cell2location和MistyR技术，专门用于空间转录组数据中的细胞类型共定位分析。

### 核心特征

- 🔬 **多样本批量处理**: 支持同时分析多个空间转录组样本
- 🧬 **Cell2location集成**: 利用单细胞参考数据进行空间细胞类型反卷积
- 📊 **多视图空间建模**: 包含Intra-cellular、Paracrine 100μm和200μm视图
- 📈 **统计整合分析**: 跨样本统计分析和相互作用强度评估
- 🎨 **可视化导向**: 丰富的热图、网络图和统计图表

### 技术优势

1. **标准化流程**: 基于成熟的分析方法，确保结果可重复性
2. **模块化设计**: 易于在不同项目中复用和扩展
3. **统计严谨**: 多样本统计分析，提高结果可靠性
4. **生物学解释**: 结合功能注释和通路分析

## 安装要求

### R环境要求
```r
# R版本要求: >= 4.0.0
R.version.string

# 必需的R包
required_packages <- c(
  "Seurat", "SeuratObject", "mistyR", "future", "future.apply",
  "dplyr", "ggplot2", "ComplexHeatmap", "circlize", "RColorBrewer",
  "pheatmap", "corrplot", "igraph", "networkD3", "plotly",
  "DT", "knitr", "rmarkdown", "readr", "stringr", "tidyr"
)

# 安装缺失的包
install.packages(setdiff(required_packages, rownames(installed.packages())))
```

### Python环境要求（用于Cell2location）
```bash
# 创建conda环境
conda create -n cell2location python=3.8
conda activate cell2location

# 安装必需包
pip install cell2location scanpy pandas numpy matplotlib seaborn
pip install scvi-tools
```

## 项目结构

```
cell2location-mistyR-mcp/
├── README.md                          # 项目说明文档
├── MistyR_Universal_Template.R        # 通用分析模板
├── MistyR_Method_Memory_Guide.md      # 方法记忆和复用指南
├── HNSCC_Focused_4Cell_Analysis.R     # HNSCC四细胞类型专项分析
├── examples/                          # 示例和使用案例
│   ├── HNSCC_example/                 # HNSCC分析示例
│   │   ├── data/                      # 示例数据
│   │   ├── results/                   # 分析结果
│   │   └── run_analysis.R             # 运行脚本
│   └── config_templates/              # 配置模板
│       ├── basic_config.R             # 基础配置
│       └── advanced_config.R          # 高级配置
├── docs/                              # 详细文档
│   ├── installation.md               # 安装指南
│   ├── tutorial.md                   # 使用教程
│   └── api_reference.md              # API参考
└── utils/                             # 工具函数
    ├── data_preprocessing.R           # 数据预处理
    ├── visualization.R                # 可视化函数
    └── statistical_analysis.R        # 统计分析函数
```

## 快速开始

### 1. 基础使用

```r
# 加载模板
source("MistyR_Universal_Template.R")

# 设置项目参数
project_name <- "My_Spatial_Analysis"
data_path <- "path/to/your/data"
output_path <- "path/to/output"

# 定义重点分析的细胞类型
focus_cell_types <- c("Treg", "Macro_Isg15", "Tumor_6", "Tumor_9")

# 运行分析
run_mistyR_analysis(
  project_name = project_name,
  data_path = data_path,
  output_path = output_path,
  focus_cell_types = focus_cell_types
)
```

### 2. HNSCC专项分析

```r
# 使用HNSCC专项分析脚本
source("HNSCC_Focused_4Cell_Analysis.R")

# 设置数据路径
data_path <- "path/to/HNSCC/data"
results_path <- "path/to/results"

# 运行四细胞类型共定位分析
run_hnscc_4cell_analysis(data_path, results_path)
```

## 核心功能

### 1. 多样本MistyR分析
- 批量处理多个空间转录组样本
- 自动化的质量控制和数据预处理
- 标准化的MistyR参数设置

### 2. 空间视图构建
- **Intra-cellular视图**: 细胞内基因表达模式
- **Paracrine 100μm视图**: 近距离细胞间相互作用
- **Paracrine 200μm视图**: 中距离细胞间相互作用

### 3. 统计分析
- 跨样本相互作用强度统计
- 重要性评分和显著性检验
- 样本间一致性分析

### 4. 可视化分析
- 相互作用热图
- 网络图分析
- 空间分布图
- 统计分布图

## 应用案例

### HNSCC样本分析
本项目已成功应用于HNSCC（头颈部鳞状细胞癌）样本的分析：
- **样本数量**: 10个HNSCC Visium样本
- **细胞类型**: 36种细胞类型
- **重点分析**: Treg、Macro_Isg15、Tumor_6、Tumor_9四种细胞类型
- **核心发现**: 
  - CD4_Treg_CTLA4 → Tumor_6 (平均重要性: 0.89)
  - CD4_Treg_CTLA4 → Macro_Isg15 (平均重要性: 0.85)
  - Tumor_6 → CD4_Treg_CTLA4 (平均重要性: 0.82)

## 配置说明

### 基础配置参数
```r
# 项目基础信息
PROJECT_NAME <- "Your_Project_Name"
DATA_PATH <- "path/to/your/data"
OUTPUT_PATH <- "path/to/output"

# 空间视图参数
SPATIAL_VIEWS <- list(
  intra = "intra",
  para_100 = list(type = "para", l = 100),
  para_200 = list(type = "para", l = 200)
)

# 细胞类型过滤
MIN_CELLS_PER_TYPE <- 50
MIN_SPOTS_PER_SAMPLE <- 100

# MistyR参数
MISTY_SEED <- 42
N_CORES <- 8
```

## 结果解释

### 1. 相互作用重要性评分
- **范围**: 0-1，越高表示相互作用越重要
- **阈值**: 通常 >0.5 被认为是显著相互作用
- **统计**: 提供平均值、中位数、标准差等统计指标

### 2. 空间共定位模式
- **正相关**: 细胞类型倾向于空间聚集
- **负相关**: 细胞类型倾向于空间分离
- **距离依赖**: 不同距离下的相互作用强度

### 3. 生物学意义
- **免疫微环境**: Treg与肿瘤细胞的空间关系
- **炎症反应**: 巨噬细胞与其他细胞类型的相互作用
- **肿瘤异质性**: 不同肿瘤亚型的空间分布模式

## 贡献指南

欢迎贡献代码和改进建议！请遵循以下步骤：

1. Fork本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启Pull Request

## 许可证

本项目采用MIT许可证 - 详见 [LICENSE](LICENSE) 文件

## 引用

如果您在研究中使用了本分析流程，请引用：

```
Cell2location-MistyR-MCP: A comprehensive pipeline for multi-sample spatial cell co-localization analysis
GitHub: https://github.com/Crorazon/c2l-mistyR-analysis
```

## 联系方式

- 项目维护者: [Your Name]
- 邮箱: [your.email@example.com]
- 问题反馈: [GitHub Issues](https://github.com/Crorazon/c2l-mistyR-analysis/issues)

## 更新日志

### v1.0.0 (2024-01-XX)
- 初始版本发布
- 包含完整的MistyR分析流程
- HNSCC专项分析功能
- 详细的文档和示例

---

**注意**: 本项目基于"单细胞空间交响乐"公众号的MistyR分析方法开发，感谢原作者的贡献。