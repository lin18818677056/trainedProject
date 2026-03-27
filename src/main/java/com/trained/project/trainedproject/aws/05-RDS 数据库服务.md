# 第 5 章：RDS 数据库服务详解

## 📖 本章目标
- 理解 RDS 的概念和优势
- 学会创建 MySQL 数据库实例
- 掌握数据库连接方法
- 配置自动备份和恢复
- 了解高可用架构
- 实践性能监控和优化

---

## 5.1 RDS 基础概念

### 5.1.1 什么是 RDS？

**RDS = Relational Database Service（关系型数据库服务）**

简单理解：
```
RDS = 托管的关系型数据库

AWS 负责:
  ✓ 硬件维护
  ✓ 数据库安装
  ✓ 补丁更新
  ✓ 备份恢复
  ✓ 故障检测
  
你负责:
  ✓ 创建数据库
  ✓ 优化查询
  ✓ 管理数据
```

### 5.1.2 支持的数据库引擎

| 引擎 | 版本 | 适用场景 | 特点 |
|------|------|----------|------|
| **MySQL** | 5.7/8.0 | Web 应用、通用 | 最流行、开源 |
| **PostgreSQL** | 12+/13+ | 复杂查询、GIS | 功能强大 |
| **MariaDB** | 10.x | MySQL 替代 | 兼容 MySQL |
| **Oracle** | 19c | 企业应用 | 商业数据库 |
| **SQL Server** | 2016+/2019+ | .NET 应用 | Windows 生态 |
| **Aurora** | - | 高性能需求 | AWS 自研 |

### 5.1.3 RDS vs EC2 自建数据库

| 对比项 | RDS | EC2 自建 |
|--------|-----|----------|
| 管理复杂度 | 低 | 高 |
| 自动化程度 | 高 | 手动 |
| 成本 | 较高 | 较低 |
| 灵活性 | 中等 | 完全控制 |
| 推荐新手 | ✅ | ❌ |

---

## 5.2 创建第一个数据库实例

### 5.2.1 选择创建方式

**标准创建**:
```
✓ 完整配置选项
✓ 适合生产环境
✓ 需要更多设置
```

**轻松创建**:
```
✓ 快速启动
✓ 简化配置
✓ 适合学习测试
```

### 5.2.2 详细步骤（以 MySQL 为例）

#### 步骤 1: 进入 RDS 控制台
```
1. AWS 控制台搜索 "RDS"
2. 点击进入 RDS 服务
3. 左侧菜单：数据库
```

#### 步骤 2: 创建数据库
```
点击 "创建数据库" 按钮
```

#### 步骤 3: 选择创建方法
```
☑ 标准创建
  - 完全控制配置
  - 适合学习所有选项
```

#### 步骤 4: 选择引擎

```
引擎选项:
  ☑ MySQL
    版本：8.0.x
  
其他选项:
  ○ PostgreSQL
  ○ MariaDB
  ○ Oracle
  ○ SQL Server
  ○ Aurora
```

**推荐新手选择 MySQL 8.0**

#### 步骤 5: 选择模板

**免费套餐**:
```
☑ 符合条件：1 台 db.t2.micro 实例
   750 小时/月 免费
   
适用范围:
  - t2.micro (1 vCPU, 1GB RAM)
  - 单可用区
  - 20GB 存储
```

**开发/测试**:
```
适用于非生产环境
按需付费
```

**生产**:
```
多可用区部署
自动故障转移
更高配置
```

**选择：免费套餐**

#### 步骤 6: 指定凭据

```
主用户名：admin
  - 默认管理员账户
  - 不要用 root（已被占用）

密码认证:
  ● 自动生成主密码
    - 下载并保存
    - 只显示一次
    
  ○ 自己输入主密码
    - 至少 8 个字符
    - 包含大小写字母、数字
    - 示例：MyDbPass123!
```

**⚠️ 重要**: 妥善保管密码！

#### 步骤 7: 配置 DB 实例大小

```
实例配置:
  突发性能类 (t2, t3)
  
  具体类型:
    db.t2.micro (免费套餐)
      - 1 vCPU
      - 1 GB 内存
      - 适合学习
      
    db.t2.small
      - 1 vCPU
      - 2 GB 内存
      
    db.t3.medium
      - 2 vCPU
      - 4 GB 内存
```

#### 步骤 8: 配置存储

```
存储类型:
  ☑ 通用型 SSD (gp2/gp3)
    - 性价比高
    - 适合大多数场景
    
  ○ 预配置 IOPS (io1/io2)
    - 高性能
    - 成本较高
    
  ○ 磁性存储
    - 最低成本
    - 性能较低

分配存储:
  初始大小：20 GB (免费套餐上限)
  
  范围：
    - MySQL: 20 GB - 16 TB
    
存储自动扩展:
  ☐ 启用（可选）
    - 最大阈值：100 GB
    - 避免磁盘满
```

#### 步骤 9: 网络和安全

**网络**:
```
虚拟私有云 (VPC):
  选择：default VPC
  
子网组:
  创建子网组或选择默认
  
公有访问:
  ☑ 是（学习用途）
    - 可以从外网访问
    
  ○ 否（生产推荐）
    - 仅内部访问
```

**安全组**:
```
☑ 创建新安全组
  名称：sg-rds-mysql
  
入站规则:
  类型：MySQL/Aurora
  端口：3306
  来源：
    - 我的 IP（推荐）
    - 或指定安全组
```

**可用性和耐久性**:
```
多可用区:
  ○ 创建备用实例（生产用）
    - 自动故障转移
    - 提高可用性
    - 双倍费用
    
  ● 不创建备用实例（学习用）
    - 单可用区
    - 成本低
```

#### 步骤 10: 数据库身份验证

```
IAM 凭证:
  ☐ 不使用（使用密码认证）
  
如果使用 IAM:
  ☑ 使用 IAM 进行身份验证
    - 更安全
    - 无需密码
    - 需要配置 IAM
```

#### 步骤 11: 附加配置

**数据库名称**:
```
初始数据库名：mydb
  - 创建的第一个数据库
  - 留空则只创建实例
  
端口：3306 (MySQL 默认)
```

**参数组**:
```
保持默认即可
后续可以自定义
```

**选项组**:
```
保持默认
```

**自动备份**:
```
备份保留期：7 天
  - 范围：0-35 天
  - 0 = 禁用备份（不推荐）
  
备份窗口:
  默认：凌晨时段
  可自定义
```

**性能 Insights**:
```
☐ 启用（会产生费用）
  学习期间不建议
```

**日志导出**:
```
慢查询日志
错误日志
根据需求选择
```

**维护**:
```
自动小版本升级:
  ☑ 启用（推荐）
  
维护窗口:
  默认：周日凌晨
```

**删除保护**:
```
☐ 启用（防止误删）
  学习期间可以不启用
```

#### 步骤 12: 创建数据库
```
滚动到底部
点击 "创建数据库"
等待创建完成（约 5-10 分钟）
```

---

## 5.3 连接数据库

### 5.3.1 获取连接信息

**在 RDS 控制台查看**:
```
1. 选择数据库实例
2. 查看"连接和信息"标签

需要的信息:
  - 端点：mydb.xxx.us-east-1.rds.amazonaws.com
  - 端口：3306
  - 用户名：admin
  - 密码：创建时设置的
```

### 5.3.2 使用 MySQL Workbench 连接

#### 下载安装
```
1. 访问：https://dev.mysql.com/downloads/workbench/
2. 下载对应系统版本
3. 安装 MySQL Workbench
```

#### 配置连接

**步骤 1: 新建连接**
```
1. 打开 MySQL Workbench
2. 点击 "+" 号
3. 填写连接名称：MyAWS-RDS
```

**步骤 2: 填写参数**
```
Connection Method: Standard (TCP/IP)

Hostname: 
  复制 RDS 端点（不含端口）
  例如：mydb.xxx.us-east-1.rds.amazonaws.com

Port: 3306

Username: admin

Password: 
  点击 "Store in Vault..."
  输入密码
  点击 OK
```

**步骤 3: 测试连接**
```
点击 "Test Connection"
应该显示连接成功
```

**步骤 4: 保存并连接**
```
点击 OK 保存
双击新建的连接
进入数据库管理界面
```

### 5.3.3 使用命令行连接

**Linux/Mac**:
```bash
mysql -h mydb.xxx.us-east-1.rds.amazonaws.com \
  -P 3306 \
  -u admin \
  -p
```

**Windows**:
```cmd
mysql -h mydb.xxx.us-east-1.rds.amazonaws.com -P 3306 -u admin -p
```

**输入密码后**:
```
Welcome to the MySQL monitor...

mysql>
```

### 5.3.4 使用编程语言连接

#### Python (PyMySQL)
```python
import pymysql

# 建立连接
connection = pymysql.connect(
    host='mydb.xxx.us-east-1.rds.amazonaws.com',
    port=3306,
    user='admin',
    password='YourPassword123!',
    database='mydb',
    charset='utf8mb4'
)

try:
    with connection.cursor() as cursor:
        # 执行 SQL
        sql = "SELECT VERSION()"
        cursor.execute(sql)
        result = cursor.fetchone()
        print(f"MySQL 版本：{result}")
        
finally:
    connection.close()
```

#### Java (JDBC)
```java
String url = "jdbc:mysql://mydb.xxx.us-east-1.rds.amazonaws.com:3306/mydb";
String user = "admin";
String password = "YourPassword123!";

Connection conn = DriverManager.getConnection(url, user, password);
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery("SELECT VERSION()");
```

#### Node.js
```javascript
const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'mydb.xxx.us-east-1.rds.amazonaws.com',
  port: 3306,
  user: 'admin',
  password: 'YourPassword123!',
  database: 'mydb'
});

connection.query('SELECT VERSION()', (error, results) => {
  console.log('MySQL 版本:', results[0]['VERSION()']);
  connection.end();
});
```

---

## 5.4 基本数据库操作

### 5.4.1 数据库管理

```sql
-- 查看所有数据库
SHOW DATABASES;

-- 创建数据库
CREATE DATABASE shop_db;

-- 选择数据库
USE shop_db;

-- 删除数据库
DROP DATABASE shop_db;

-- 查看当前数据库
SELECT DATABASE();
```

### 5.4.2 表操作

**创建表**:
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**查看表结构**:
```sql
-- 查看所有表
SHOW TABLES;

-- 查看表结构
DESCRIBE users;

-- 查看详细创建语句
SHOW CREATE TABLE users;
```

**修改表**:
```sql
-- 添加列
ALTER TABLE users ADD COLUMN age INT;

-- 修改列
ALTER TABLE users MODIFY COLUMN email VARCHAR(150);

-- 删除列
ALTER TABLE users DROP COLUMN age;

-- 重命名表
ALTER TABLE users RENAME TO user_accounts;
```

### 5.4.3 CRUD 操作

**插入数据**:
```sql
INSERT INTO users (username, email) VALUES
('zhangsan', 'zhangsan@example.com'),
('lisi', 'lisi@example.com'),
('wangwu', 'wangwu@example.com');
```

**查询数据**:
```sql
-- 查询所有
SELECT * FROM users;

-- 条件查询
SELECT * FROM users WHERE id > 1;

-- 排序
SELECT * FROM users ORDER BY created_at DESC;

-- 限制数量
SELECT * FROM users LIMIT 10;
```

**更新数据**:
```sql
UPDATE users 
SET email = 'newemail@example.com' 
WHERE id = 1;
```

**删除数据**:
```sql
DELETE FROM users WHERE id = 1;
```

### 5.4.4 索引操作

**创建索引**:
```sql
-- 普通索引
CREATE INDEX idx_username ON users(username);

-- 唯一索引
CREATE UNIQUE INDEX idx_email ON users(email);

-- 复合索引
CREATE INDEX idx_name_age ON users(username, age);
```

**查看索引**:
```sql
SHOW INDEX FROM users;
```

**删除索引**:
```sql
DROP INDEX idx_username ON users;
```

---

## 5.5 备份和恢复

### 5.5.1 自动备份

**配置项**:
```
备份保留期：1-35 天
备份窗口：每日固定时段
```

**包含内容**:
```
✓ 整个 DB 实例
✓ 所有数据库
✓ 事务日志
```

**查看备份**:
```
1. RDS 控制台
2. 选择实例
3. 操作 → 备份
4. 查看自动快照
```

### 5.5.2 手动快照

**创建快照**:
```
1. RDS 控制台选择实例
2. 操作 → 创建快照
3. 填写快照名称
4. 描述（可选）
5. 创建
```

**CLI 方式**:
```bash
aws rds create-db-snapshot \
  --db-instance-identifier mydb \
  --db-snapshot-identifier mydb-snapshot-20240115
```

### 5.5.3 从快照恢复

**恢复到新实例**:
```
1. RDS 控制台 → 快照
2. 选择快照
3. 操作 → 还原快照
4. 配置新实例参数
5. 创建
```

**注意**:
```
✓ 会创建新实例
✓ 原实例不受影响
✓ 端点会改变
```

### 5.5.4 时间点恢复 (PITR)

**恢复到特定时间**:
```
1. RDS 控制台
2. 选择实例
3. 操作 → 还原到时间点
4. 选择目标时间
5. 配置新实例
6. 还原
```

**适用场景**:
```
✓ 误删数据
✓ 数据损坏
✓ 应用 bug 导致问题
```

---

## 5.6 高可用架构

### 5.6.1 多可用区部署

**架构**:
```
主实例 (可用区 A)
    ↓ 同步复制
备用实例 (可用区 B)
    ↓ 自动故障转移
    新主实例
```

**优点**:
```
✓ 自动故障检测
✓ 自动故障转移（通常<2 分钟）
✓ 提高可用性（99.95% SLA）
✓ 备份不影响主实例性能
```

**缺点**:
```
✗ 双倍费用
✗ 写入延迟略增
```

**启用多可用区**:
```
1. RDS 控制台
2. 选择实例
3. 操作 → 修改
4. 多可用区部署 → 创建备用实例
5. 继续
6. 计划更新
```

### 5.6.2 读取副本

**什么是读取副本？**
```
主实例的只读副本
异步复制
用于读写分离
```

**使用场景**:
```
✓ 读多写少的应用
✓ 报表分析
✓ 数据仓库
✓ 异地容灾
```

**创建读取副本**:
```
1. RDS 控制台选择主实例
2. 操作 → 创建读取副本
3. 配置副本参数
4. 创建
```

**最多支持**:
```
- MySQL: 5 个副本
- PostgreSQL: 15 个副本
- MariaDB: 5 个副本
```

### 5.6.3 读写分离示例

**应用层实现**:
```python
# 主库（写）
master_db = pymysql.connect(
    host='master.xxx.rds.amazonaws.com',
    user='admin',
    password='password',
    database='mydb'
)

# 从库（读）
replica_db = pymysql.connect(
    host='replica.xxx.rds.amazonaws.com',
    user='admin',
    password='password',
    database='mydb'
)

# 写操作
with master_db.cursor() as cursor:
    cursor.execute("INSERT INTO users ...")
master_db.commit()

# 读操作
with replica_db.cursor() as cursor:
    cursor.execute("SELECT * FROM users")
```

---

## 5.7 监控和性能优化

### 5.7.1 CloudWatch 指标

**关键指标**:

**CPU 使用率**:
```
正常：< 50%
关注：50-70%
警告：> 80%
紧急：> 90%
```

**可用内存**:
```
监控可用内存
过低会影响性能
```

**存储空间**:
```
监控剩余空间
设置告警：剩余 10%
```

**IOPS**:
```
每秒 IO 操作数
过高说明 IO 密集
```

**数据库连接数**:
```
活跃连接数
接近最大值需扩容
```

### 5.7.2 设置 CloudWatch 告警

**创建 CPU 告警**:
```
1. CloudWatch → 仪表板
2. 创建仪表板
3. 添加 RDS 指标
4. 选择 CPUUtilization
5. 设置阈值：> 80%
6. 配置通知（SNS）
7. 创建
```

### 5.7.3 Performance Insights

**功能**:
```
✓ 可视化数据库负载
✓ 识别性能瓶颈
✓ SQL 查询分析
✓ 等待事件分析
```

**启用方法**:
```
1. RDS 控制台
2. 选择实例
3. 操作 → 修改
4. Performance Insights → 启用
5. 保存
```

**查看性能**:
```
1. 实例详情
2. Performance Insights 标签
3. 查看 TOP SQL
4. 分析等待事件
```

### 5.7.4 慢查询日志

**启用慢查询日志**:
```
1. RDS 控制台
2. 参数组
3. 编辑参数
4. slow_query_log = 1
5. long_query_time = 2 (秒)
6. 保存
```

**查看慢查询**:
```
1. 日志和事件
2. 慢查询日志
3. 分析执行慢的 SQL
```

**优化建议**:
```
✓ 添加索引
✓ 优化 JOIN
✓ 避免 SELECT *
✓ 减少子查询
✓ 使用 EXPLAIN 分析
```

### 5.7.5 性能优化技巧

#### 1. 索引优化
```sql
-- 为常用查询添加索引
CREATE INDEX idx_email ON users(email);

-- 使用复合索引
CREATE INDEX idx_status_created ON orders(status, created_at);
```

#### 2. 查询优化
```sql
-- 避免
SELECT * FROM users;

-- 使用
SELECT id, username, email FROM users;

-- 避免
SELECT * FROM orders WHERE YEAR(created_at) = 2024;

-- 使用
SELECT * FROM orders 
WHERE created_at >= '2024-01-01' 
  AND created_at < '2025-01-01';
```

#### 3. 配置优化
```
innodb_buffer_pool_size: 
  设置为内存的 70-80%
  
max_connections:
  根据应用调整
  
query_cache_size:
  适当启用查询缓存
```

---

## 5.8 安全管理

### 5.8.1 安全组配置

**最佳实践**:
```
✓ 只允许必要的 IP 访问
✓ 使用安全组引用
✓ 不要开放 0.0.0.0/0
✓ 定期审查规则
```

**示例配置**:
```
入站规则:
  类型：MySQL
  端口：3306
  来源：
    - sg-web-server (Web 服务器安全组)
    - 192.168.1.0/24 (办公网络)
```

### 5.8.2 IAM 数据库认证

**优点**:
```
✓ 无需管理密码
✓ 集中权限控制
✓ 临时凭证更安全
```

**配置步骤**:
```
1. 创建 IAM 角色
2. 附加 RDS 访问策略
3. 修改 DB 实例启用 IAM 认证
4. 创建 IAM 用户映射
```

### 5.8.3 SSL/TLS 加密

**强制 SSL 连接**:
```
1. 修改参数组
2. require_secure_transport = 1
3. 保存并重启
```

**客户端连接**:
```bash
mysql -h endpoint \
  --ssl-ca=rds-ca-bundle.pem \
  --ssl-mode=VERIFY_IDENTITY
```

---

## 5.9 成本优化

### 5.9.1 选择合适的实例类型

**学习/开发**:
```
db.t2.micro (免费套餐)
db.t2.small
```

**测试**:
```
db.t3.medium
db.t3.large
```

**生产**:
```
db.m5.large
db.m5.xlarge
db.r5.large (内存优化)
```

### 5.9.2 预留实例

**承诺期限**:
```
1 年期：节省约 40%
3 年期：节省约 60%
```

**付款选项**:
```
全部预付：折扣最大
部分预付：中等折扣
无预付：折扣较小
```

### 5.9.3 停止未使用实例

**开发环境**:
```
工作日运行
周末和晚上停止
```

**自动化**:
```
使用 Lambda + EventBridge
定时启停实例
```

---

## 5.10 故障排查

### 问题 1: 无法连接

**现象**:
```
ERROR 2003: Can't connect to MySQL server
```

**排查**:
```
1. 检查实例状态：是否运行中
2. 检查安全组：是否开放 3306
3. 检查公有访问：是否启用
4. 检查用户名密码：是否正确
5. 检查端点：是否正确
```

### 问题 2: 连接超时

**原因**:
```
- 网络问题
- 安全组限制
- 实例过载
```

**解决**:
```
1. ping 测试
2. telnet 端口测试
3. 检查 CloudWatch 指标
4. 查看安全组规则
```

### 问题 3: 磁盘空间不足

**监控**:
```
设置 FreeStorageSpace 告警
阈值：< 5GB
```

**解决**:
```
1. 清理无用数据
2. 删除旧备份
3. 增加存储容量
```

### 问题 4: CPU 持续高企

**分析**:
```
1. 查看 Performance Insights
2. 分析 TOP SQL
3. 检查慢查询日志
```

**优化**:
```
1. 优化慢 SQL
2. 添加索引
3. 升级实例类型
```

---

## 5.11 最佳实践清单

### 设计阶段
```
□ 选择合适的数据库引擎
□ 确定实例规格
□ 规划存储容量
□ 设计网络架构
```

### 部署阶段
```
□ 使用参数组管理配置
□ 配置自动备份
□ 设置监控告警
□ 启用增强监控
```

### 运维阶段
```
□ 定期查看性能指标
□ 分析慢查询日志
□ 及时应用补丁
□ 定期测试备份恢复
```

### 安全加固
```
□ 最小权限原则
□ 启用 SSL
□ 定期更换密码
□ 审计访问日志
```

---

## 5.12 学习检查清单

### ✅ 理论知识
- [ ] 理解 RDS 的核心价值
- [ ] 知道不同引擎的区别
- [ ] 了解高可用方案
- [ ] 明白备份恢复机制

### ✅ 实践技能
- [ ] 成功创建 RDS 实例
- [ ] 能够连接数据库
- [ ] 会创建和管理快照
- [ ] 配置监控告警
- [ ] 优化数据库性能

### ✅ 安全检查
- [ ] 正确配置安全组
- [ ] 设置了强密码
- [ ] 限制了访问来源
- [ ] 启用了加密传输

---

## 5.13 实践任务

### 任务 1: 创建 MySQL 实例（30 分钟）
```
□ 选择免费套餐
□ 配置基本参数
□ 设置安全组
□ 等待实例就绪
```

### 任务 2: 连接数据库（20 分钟）
```
□ 安装 MySQL Workbench
□ 配置连接
□ 测试连接
□ 创建测试数据库
```

### 任务 3: 数据库操作（30 分钟）
```
□ 创建表结构
□ 插入测试数据
□ 执行 CRUD 操作
□ 创建索引
```

### 任务 4: 备份恢复演练（30 分钟）
```
□ 创建手动快照
□ 删除一些数据
□ 从快照恢复
□ 验证数据完整性
```

### 任务 5: 监控配置（20 分钟）
```
□ 查看 CloudWatch 指标
□ 创建 CPU 告警
□ 启用慢查询日志
□ 分析一条慢 SQL
```

---

## 5.14 常见问题 FAQ

### Q1: RDS 免费套餐包括什么？
**A**: db.t2.micro 实例，750 小时/月，20GB 存储，12 个月。

### Q2: 如何重置主密码？
**A**: RDS 控制台 → 修改 → 输入新密码 → 立即应用。

### Q3: 可以本地访问 RDS 吗？
**A**: 可以，需启用公有访问并配置安全组。

### Q4: 自动备份会影响性能吗？
**A**: 轻微影响，建议在业务低峰期备份。

### Q5: 如何迁移本地 MySQL 到 RDS？
**A**: 使用 mysqldump 导出导入，或使用 AWS DMS。

### Q6: RDS 支持自定义配置吗？
**A**: 支持，通过参数组和选项组配置。

### Q7: 实例变慢怎么办？
**A**: 
1. 检查性能指标
2. 分析慢 SQL
3. 考虑升级实例
4. 添加读取副本

---

## 5.15 下一步

恭喜你完成第五章！

现在你已经：
- ✅ 掌握了 RDS 核心概念
- ✅ 会创建和管理数据库
- ✅ 能连接和操作 MySQL
- ✅ 配置备份和监控
- ✅ 了解高可用架构

**接下来**:
请打开 **[06-VPC 网络服务.md](./06-VPC 网络服务.md)**

学习 AWS 网络服务：
- 构建虚拟私有云
- 配置子网和路由
- 设置 NAT 网关
- 建立 VPN 连接

---

## 💡 小贴士

> "数据库是应用的核心。RDS 让你专注于数据和应用逻辑，而不是基础设施维护。记住：定期测试备份恢复，这会在关键时刻拯救你的项目！"

**进阶学习**:
1. Aurora 无服务器数据库
2. Database Migration Service (DMS)
3. ElastiCache 缓存服务
4. Redshift 数据仓库
5. DynamoDB NoSQL 数据库

继续加油！🚀
