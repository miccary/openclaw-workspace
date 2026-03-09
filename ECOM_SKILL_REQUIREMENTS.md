# ECOM AI 平台 Skill 需求清单（OpenClaw）

## A. 必备技能（优先安装/启用）

1) **github**
- 用途：代码仓库管理、Issue/PR、CI查看
- 你会用到：采集脚本迭代、ETL版本管理、看板SQL变更追踪

2) **notion**
- 用途：日报/复盘/审计日志归档
- 你会用到：自动写入运营日报、风险事件记录

3) **coding-agent**
- 用途：中大型代码任务委派（爬虫、ETL、API）
- 你会用到：快速搭建抓取器、重构ETL流水线

4) **healthcheck**
- 用途：主机与OpenClaw安全审计/加固
- 你会用到：定期安全检查、权限收敛

5) **summarize**
- 用途：快速总结URL/文档（竞品分析、政策更新）
- 你会用到：对竞品页面、规则文档做快速摘要

---

## B. 推荐技能（按需）

6) **memory-system-v2**
- 用途：沉淀长期决策与策略记忆
- 场景：记录“哪些投放策略在何种品类有效”

7) **weather**
- 用途：季节性品类关联分析（可选）
- 场景：户外类目需求预判辅助

8) **Agent Browser**
- 用途：复杂网页结构抓取/自动化操作
- 场景：反爬较强页面的补充抓取

---

## C. 建议新增的自定义 Skills（你后续可做）

1) `ecom-daily-ingest`
- 目标：统一执行销量/广告/库存采集
- 输入：平台账号配置、日期区间
- 输出：标准化CSV/入库结果

2) `ecom-etl-quality`
- 目标：清洗、去重、异常检测
- 输出：质量报告（空值率、重复率、延迟）

3) `ecom-bi-refresh`
- 目标：刷新Power BI/Metabase数据源并记录状态

4) `ecom-ai-reporter`
- 目标：从数据库生成晨报/午报/晚报并推送到钉钉/Telegram/Notion

5) `ecom-risk-guard`
- 目标：库存低于阈值、ACOS异常、评分下滑时告警

---

## D. Skill 接口规范（建议统一）
- 入参：`date`, `marketplace`, `sku/asin`, `dry_run`
- 出参：`status`, `summary`, `metrics`, `errors`
- 日志：统一写 `OC日志` + 本地审计文件
- 失败策略：重试3次，仍失败则切备份链路并告警

---

## E. 你的下一步（最小可行）
1. 先启用：github / notion / healthcheck / coding-agent / summarize
2. 先做一个自定义 skill：`ecom-ai-reporter`
3. 先跑通一个闭环：
   - 读取 `sales_daily + ads_daily + inventory`
   - 生成日报
   - 推送到 Telegram + 写入 Notion
