# WORK OS Commands

## 可用数据库
- Work Log
- Daily Planner
- Project Briefs
- Action Items

## 触发命令

### 1) 同步WORK OS
作用：联通检查 + 同步读取四个数据库的可见状态。

### 2) 早间检查（morning check）
作用：读取 Daily Planner + Action Items，输出今日 Top 3。

### 3) 下午进展（afternoon progress）
作用：回写/更新当日进展到 Work Log，并更新相关任务状态。

### 4) 晚间复盘（night review）
作用：生成当日总结，回写 Work Log / Project Briefs。

## 审计日志命令

### 导入审计日志
作用：将当前审计日志写入 Notion「OC日志」数据库（UTF-8，避免中文乱码）。
