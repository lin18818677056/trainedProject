# 第 7 章：Lambda 无服务器计算

## 📖 本章目标
- 理解无服务器和 Lambda 概念
- 学会创建第一个 Lambda 函数
- 掌握事件驱动架构模式
- 了解与其他 AWS 服务集成
- 实践构建 Serverless 应用
- 配置监控和性能优化

---

## 7.1 无服务器基础

### 7.1.1 什么是无服务器？

**无服务器计算 = Serverless Computing**

简单理解：
```
无服务器 ≠ 没有服务器

而是:
  ✓ 无需管理服务器
  ✓ 自动扩展
  ✓ 按执行付费
  ✓ 事件驱动
  ✓ 按需运行
```

### 7.1.2 传统 vs 无服务器

| 对比项 | 传统 EC2 | Lambda |
|--------|----------|--------|
| 服务器管理 | 需要 | 不需要 |
| 扩展 | 手动/自动 | 全自动 |
| 计费 | 按小时 | 按毫秒 |
| 闲置成本 | 有 | 无 |
| 运维复杂度 | 高 | 低 |

### 7.1.3 Lambda 适用场景

**适合使用 Lambda**:
```
✅ 图片/视频处理
✅ 实时数据分析
✅ Web API 后端
✅ 定时任务
✅ 文件处理
✅ IoT 数据处理
✅ Chatbot
```

**不适合**:
```
❌ 长时间运行任务（>15 分钟）
❌ 需要持久连接的应用
❌ 大型单体应用
❌ 需要 GPU 的任务
```

### 7.1.4 Lambda 核心概念

**函数 (Function)**:
```
你的代码 + 配置
执行特定任务
```

**运行时 (Runtime)**:
```
支持的语言:
  - Python 3.8/3.9/3.10
  - Node.js 14/16/18
  - Java 8/11/17
  - Go 1.x
  - C# (.NET Core)
  - Ruby
  - PHP
  - 自定义运行时
```

**触发器 (Trigger)**:
```
触发函数执行的事件源:
  - API Gateway
  - S3
  - DynamoDB
  - CloudWatch Events
  - SNS/SQS
  - 等等
```

**执行角色 (Execution Role)**:
```
IAM 角色
定义函数的权限
```

---

## 7.2 创建第一个 Lambda 函数

### 7.2.1 快速创建

#### 步骤 1: 进入 Lambda 控制台
```
1. AWS 控制台搜索 "Lambda"
2. 点击进入 Lambda 服务
```

#### 步骤 2: 创建函数
```
点击 "创建函数"
```

#### 步骤 3: 选择创建方式
```
☑ 从头开始创作
  - 完全控制配置
  
○ 使用蓝图
  - 预定义模板
  
○ 从现有资源创建
  - 从容器镜像等
```

选择：**从头开始创作**

#### 步骤 4: 基本信息
```
函数名称：hello-world
运行时：Python 3.9
  - 新手推荐 Python
  
架构：x86_64

权限:
  ○ 创建新 IAM 角色
    - 基本权限
    
  ○ 使用现有角色
    - 如果有
  
  ● 自定义角色
    - 高级控制

选择：**创建新 IAM 角色**

角色名称：lambda-basic-role
```

#### 步骤 5: 创建
```
点击 "创建函数"
等待创建完成
```

### 7.2.2 编写代码

**默认代码**:
```python
def lambda_handler(event, context):
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
```

**修改为**:
```python
import json

def lambda_handler(event, context):
    """
    Lambda 函数入口
    
    参数:
        event: 触发事件的详情
        context: 运行时信息
    
    返回:
        dict: HTTP 响应格式
    """
    
    # 获取输入参数（如果有）
    name = event.get('name', 'World') if event else 'World'
    
    # 构建响应
    response = {
        'statusCode': 200,
        'body': json.dumps({
            'message': f'Hello, {name}!',
            'timestamp': str(context.aws_request_id)
        })
    }
    
    return response
```

### 7.2.3 测试函数

#### 配置测试事件
```
1. 点击 "测试" 按钮
2. 选择 "创建新事件"
3. 事件名称：TestEvent
4. 事件 JSON:
   {
     "name": "AWS Learner"
   }
5. 点击 "保存"
```

#### 执行测试
```
1. 选择刚创建的测试事件
2. 点击 "测试"
3. 查看结果

成功输出:
{
  "statusCode": 200,
  "body": {
    "message": "Hello, AWS Learner!",
    "timestamp": "xxx-xxx-xxx"
  }
}
```

### 7.2.4 查看日志

**CloudWatch Logs**:
```
1. 函数页面 → 监控
2. 查看 CloudWatch Logs
3. 点击日志流
4. 查看详细日志
```

**日志内容**:
```
START RequestId: xxx Version: $LATEST
[INFO] ... 日志信息
END RequestId: xxx
REPORT Duration: xx ms
```

---

## 7.3 Lambda 配置详解

### 7.3.1 常规设置

**内存和超时**:
```
内存：128 MB - 10,240 MB
  - 步长：1 MB
  - 推荐：1024 MB（学习用）
  
超时：1 秒 - 15 分钟
  - 默认：3 秒
  - 根据需求调整
  
CPU:
  - 与内存成比例
  - 内存越大 CPU 越多
```

**定价示例**:
```
假设：1024 MB，运行 1 秒，每月 100 万次请求

计算：
  100 万 × 1 秒 × 1 GB = 1,000,000 GB-秒
  价格：$0.0000166667/GB-秒
  费用：约 $16.67
  
免费套餐:
  每月 400,000 GB-秒
  足够学习使用
```

### 7.3.2 环境变量

**添加环境变量**:
```
1. 配置标签
2. 环境变量
3. 编辑

示例:
  DB_HOST = mydb.xxx.rds.amazonaws.com
  DB_USER = admin
  LOG_LEVEL = INFO
  API_KEY = your-secret-key
```

**代码中使用**:
```python
import os

def lambda_handler(event, context):
    db_host = os.environ.get('DB_HOST')
    log_level = os.environ.get('LOG_LEVEL', 'INFO')
    
    # 使用变量
    print(f"Connecting to {db_host}")
```

### 7.3.3 并发控制

**预留并发**:
```
限制函数最大并发数
防止耗尽账户资源

设置:
  配置 → 并发
  预留并发：100
```

**账户级限制**:
```
默认：1000 并发
可以申请提高
```

### 7.3.4 版本和别名

**版本**:
```
函数的快照
不可变
用于发布和回滚
```

**发布版本**:
```
1. 操作 → 发布新版本
2. 版本号：1
3. 描述：Initial release
```

**别名**:
```
指向版本的指针
可以动态更新

常用别名:
  - $LATEST (最新开发版)
  - DEV (开发环境)
  - STAGING (测试环境)
  - PROD (生产环境)
```

**流量切换**:
```
别名可以分配流量:
  PROD: 
    - 版本 1: 90%
    - 版本 2: 10%
```

---

## 7.4 触发器配置

### 7.4.1 API Gateway 触发器

**创建 REST API**:
```
1. Lambda 函数页面
2. 添加触发器
3. 选择 API Gateway
4. 选择 API: 创建新 API
5. API 类型：HTTP API
6. 安全：开放
7. 部署
```

**获取 API URL**:
```
API Gateway 控制台
→ API
→ 端点
https://xxx.execute-api.us-east-1.amazonaws.com
```

**测试 API**:
```bash
curl https://xxx.execute-api.us-east-1.amazonaws.com/hello

响应:
{"message":"Hello, World!","timestamp":"xxx"}
```

**带参数调用**:
```bash
curl "https://xxx/api?name=Alice"

或使用 POST:
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"name":"Bob"}' \
  https://xxx/api
```

### 7.4.2 S3 触发器

**场景**: 图片上传后自动处理

**配置步骤**:

**1. 创建 S3 存储桶**:
```
名称：my-image-bucket
区域：与 Lambda 相同
```

**2. 添加 S3 触发器**:
```
Lambda → 添加触发器
选择 S3
存储桶：my-image-bucket
事件类型：PUT (Object Created)
```

**3. 编写处理代码**:
```python
import boto3

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    
    # 获取上传的文件信息
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        
        print(f"New file uploaded: {bucket}/{key}")
        
        # 这里可以添加处理逻辑
        # 例如：生成缩略图、分析图片等
        
    return {
        'statusCode': 200,
        'body': 'Processing complete'
    }
```

**4. 测试**:
```
1. 上传图片到 S3
2. 查看 Lambda 是否触发
3. 检查 CloudWatch 日志
```

### 7.4.3 CloudWatch Events 触发器

**场景**: 定时任务（cron job）

**配置定时触发器**:
```
1. Lambda → 添加触发器
2. 选择 EventBridge (CloudWatch Events)
3. 创建新规则
4. 规则名称：daily-backup
5. 规则类型:
   
   固定频率:
     每 5 分钟
   
   Cron 表达式:
     cron(0 2 * * ? *) 
     - 每天凌晨 2 点
     
     cron(0 */15 * * * ? *)
     - 每 15 分钟
```

**定时任务示例**:
```python
import boto3
from datetime import datetime

def lambda_handler(event, context):
    """
    每日备份任务
    """
    print(f"Backup started at {datetime.now()}")
    
    # 执行备份逻辑
    # 1. 创建数据库快照
    # 2. 复制文件
    # 3. 清理旧备份
    
    print("Backup completed successfully")
    
    return {'status': 'success'}
```

### 7.4.4 DynamoDB 触发器

**场景**: 数据变更实时处理

**启用 DynamoDB 流**:
```
1. DynamoDB 控制台
2. 选择表
3. 导出和流
4. 启用流
```

**添加触发器**:
```
Lambda → 添加触发器
选择 DynamoDB
表：your-table
批处理大小：100
起始位置：最新
```

**处理代码**:
```python
def lambda_handler(event, context):
    for record in event['Records']:
        event_name = record['eventName']
        
        if event_name == 'INSERT':
            new_item = record['dynamodb']['NewImage']
            print(f"New item inserted: {new_item}")
            
        elif event_name == 'MODIFY':
            old = record['dynamodb']['OldImage']
            new = record['dynamodb']['NewImage']
            print(f"Item modified from {old} to {new}")
            
        elif event_name == 'REMOVE':
            old_item = record['dynamodb']['OldImage']
            print(f"Item removed: {old_item}")
```

---

## 7.5 实战项目

### 7.5.1 项目一：图片处理服务

**需求**:
```
用户上传原图到 S3
Lambda 自动生成缩略图
保存到另一个 S3 存储桶
```

**架构**:
```
用户 → S3 (原图) → Lambda → S3 (缩略图)
```

**完整代码**:
```python
import boto3
from PIL import Image
import io
import os

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    
    # 获取环境配置
    dest_bucket = os.environ['DEST_BUCKET']
    
    # 处理每个上传的文件
    for record in event['Records']:
        source_bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        
        # 下载原图
        obj = s3.get_object(Bucket=source_bucket, Key=key)
        image_data = obj['Body'].read()
        
        # 打开图片
        img = Image.open(io.BytesIO(image_data))
        
        # 生成缩略图（200x200）
        img.thumbnail((200, 200))
        
        # 保存到内存
        output = io.BytesIO()
        img.save(output, format=img.format)
        output.seek(0)
        
        # 上传缩略图
        thumb_key = f"thumbs/{key}"
        s3.upload_fileobj(
            output,
            dest_bucket,
            thumb_key,
            ExtraArgs={'ContentType': obj['ContentType']}
        )
        
        print(f"Created thumbnail: {thumb_key}")
    
    return {'statusCode': 200}
```

**部署步骤**:
```
1. 创建两个 S3 存储桶
   - original-images
   - thumbnail-images

2. 创建 Lambda 函数
   - 上传代码（需要打包 PIL）
   - 或使用 Lambda Layer

3. 配置 S3 触发器
   - 监听 original-images 的 PUT 事件

4. 设置环境变量
   - DEST_BUCKET = thumbnail-images

5. 测试
   - 上传原图
   - 验证缩略图生成
```

### 7.5.2 项目二：Serverless Web API

**需求**:
```
创建待办事项 API
支持 CRUD 操作
使用 DynamoDB 存储
```

**架构**:
```
API Gateway → Lambda → DynamoDB
```

**DynamoDB 表结构**:
```
表名：todos
分区键：id (String)
排序键：无
属性:
  - title (String)
  - completed (Boolean)
  - createdAt (Number)
```

**Lambda 代码**:
```python
import json
import boto3
import uuid
import time
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('todos')

def lambda_handler(event, context):
    http_method = event['httpMethod']
    
    if http_method == 'GET':
        return get_todos(event)
    elif http_method == 'POST':
        return create_todo(event)
    elif http_method == 'PUT':
        return update_todo(event)
    elif http_method == 'DELETE':
        return delete_todo(event)

def get_todos(event):
    # 获取所有待办
    response = table.scan()
    
    return {
        'statusCode': 200,
        'body': json.dumps(response['Items'])
    }

def create_todo(event):
    body = json.loads(event['body'])
    
    todo = {
        'id': str(uuid.uuid4()),
        'title': body['title'],
        'completed': False,
        'createdAt': int(time.time())
    }
    
    table.put_item(Item=todo)
    
    return {
        'statusCode': 201,
        'body': json.dumps(todo)
    }

def update_todo(event):
    todo_id = event['pathParameters']['id']
    body = json.loads(event['body'])
    
    table.update_item(
        Key={'id': todo_id},
        UpdateExpression='SET title = :t, completed = :c',
        ExpressionAttributeValues={
            ':t': body.get('title'),
            ':c': body.get('completed', False)
        }
    )
    
    return {'statusCode': 200}

def delete_todo(event):
    todo_id = event['pathParameters']['id']
    
    table.delete_item(Key={'id': todo_id})
    
    return {'statusCode': 204}
```

**API Gateway 配置**:
```
创建 REST API
资源：/todos

方法:
  GET → Lambda (get_todos)
  POST → Lambda (create_todo)
  
资源：/todos/{id}

方法:
  PUT → Lambda (update_todo)
  DELETE → Lambda (delete_todo)
```

**测试**:
```bash
# 创建
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"title":"Learn AWS"}' \
  https://xxx.execute-api.amazonaws.com/todos

# 获取所有
curl https://xxx.execute-api.amazonaws.com/todos

# 更新
curl -X PUT \
  -H "Content-Type: application/json" \
  -d '{"title":"Master AWS","completed":true}' \
  https://xxx.execute-api.amazonaws.com/todos/{id}

# 删除
curl -X DELETE \
  https://xxx.execute-api.amazonaws.com/todos/{id}
```

---

## 7.6 最佳实践

### 7.6.1 代码组织

**分层结构**:
```
/
├── src/
│   ├── handlers.py      # Lambda 入口
│   ├── utils.py         # 工具函数
│   └── config.py        # 配置
├── tests/               # 测试
├── requirements.txt     # 依赖
└── template.yaml        # SAM 模板
```

### 7.6.2 错误处理

```python
def lambda_handler(event, context):
    try:
        # 业务逻辑
        result = process_data(event)
        
        return {
            'statusCode': 200,
            'body': json.dumps(result)
        }
    except ValueError as e:
        # 参数错误
        return {
            'statusCode': 400,
            'body': json.dumps({'error': str(e)})
        }
    except Exception as e:
        # 其他错误
        print(f"Unexpected error: {e}")
        
        # 记录详细错误到 CloudWatch
        context.log_stream_name
        
        raise  # 重新抛出异常
```

### 7.6.3 日志记录

```python
import logging
import os

# 设置日志级别
log_level = os.environ.get('LOG_LEVEL', 'INFO')
logging.basicConfig(level=getattr(logging, log_level))
logger = logging.getLogger()

def lambda_handler(event, context):
    logger.info(f"Received event: {json.dumps(event)}")
    
    try:
        # 业务逻辑
        logger.debug("Processing data...")
        result = process_data(event)
        logger.info(f"Success: {result}")
        
    except Exception as e:
        logger.error(f"Error occurred: {str(e)}", exc_info=True)
        raise
```

### 7.6.4 性能优化

**冷启动优化**:
```python
# 在函数外初始化客户端
boto3_client = boto3.client('dynamodb')

def lambda_handler(event, context):
    # 直接使用，无需重复创建
    return boto3_client.describe_table(...)
```

**内存优化**:
```
分析实际内存使用
CloudWatch → 内存使用情况
调整到合适值
避免过度配置
```

**连接复用**:
```python
# 全局连接池
import psycopg2
from psycopg2 import pool

connection_pool = pool.SimpleConnectionPool(
    1, 20,
    host=os.environ['DB_HOST'],
    database=os.environ['DB_NAME'],
    user=os.environ['DB_USER']
)

def lambda_handler(event, context):
    conn = connection_pool.getconn()
    try:
        # 使用连接
        pass
    finally:
        connection_pool.putconn(conn)
```

---

## 7.7 监控和调试

### 7.7.1 CloudWatch 指标

**关键指标**:
```
Invocations: 调用次数
Errors: 错误次数
Duration: 执行时间
Throttles: 限流次数
ConcurrentExecutions: 并发数
```

### 7.7.2 X-Ray 追踪

**启用 X-Ray**:
```
1. Lambda → 配置
2. 监控和故障排除
3. X-Ray → 启用
```

**代码中集成**:
```python
from aws_xray_sdk.core import xray_recorder

@xray_recorder.capture('process_data')
def process_data(event):
    # 这个函数会被追踪
    pass
```

**查看追踪**:
```
X-Ray 控制台
→ 服务地图
→ 查看完整链路
```

### 7.7.3 本地调试

**使用 SAM CLI**:
```bash
# 安装 SAM
pip install aws-sam-cli

# 本地 invoke
sam local invoke HelloWorldFunction \
  --event events/test.json

# 本地 API
sam local start-api

# 调试模式
sam local invoke \
  --debug-port 5858 \
  --debugger-path .
```

---

## 7.8 成本管理

### 7.8.1 免费套餐

```
每月:
  - 100 万次请求
  - 400,000 GB-秒计算时间
  
足够个人学习和小型项目
```

### 7.8.2 成本估算

**计算器示例**:
```
假设:
  - 每月 500 万次请求
  - 平均执行时间 500ms
  - 内存 1024 MB

计算:
  请求费用：超出免费部分 400 万
    4,000,000 × $0.20/百万 = $0.80
    
  计算费用：
    5,000,000 × 0.5 秒 × 1 GB = 2,500,000 GB-秒
    2,500,000 × $0.0000166667 = $41.67
    
  总计：约 $42.47/月
```

### 7.8.3 优化技巧

```
✓ 减少执行时间
✓ 选择合适的内存
✓ 使用预留并发（生产）
✓ 清理未使用的函数
✓ 合并小函数
```

---

## 7.9 学习检查清单

### ✅ 理论知识
- [ ] 理解无服务器的优势
- [ ] 知道 Lambda 的计费方式
- [ ] 了解常见触发器类型
- [ ] 明白冷启动概念

### ✅ 实践技能
- [ ] 成功创建 Lambda 函数
- [ ] 配置了 API Gateway 触发器
- [ ] 实现了 S3 事件处理
- [ ] 创建了定时任务
- [ ] 调试了本地代码

### ✅ 安全检查
- [ ] 配置了最小权限 IAM
- [ ] 使用了环境变量存储敏感信息
- [ ] 启用了 X-Ray 追踪
- [ ] 设置了适当的超时

---

## 7.10 实践任务

### 任务 1: Hello World 函数（15 分钟）
```
□ 创建 Python Lambda
□ 编写问候代码
□ 测试执行
□ 查看日志
```

### 任务 2: API Gateway 集成（30 分钟）
```
□ 创建 HTTP API
□ 连接 Lambda
□ 测试 API 调用
□ 处理查询参数
```

### 任务 3: S3 触发器（30 分钟）
```
□ 创建 S3 存储桶
□ 配置 Lambda 触发器
□ 编写文件处理代码
□ 测试上传触发
```

### 任务 4: 定时任务（20 分钟）
```
□ 创建 CloudWatch 触发器
□ 设置 cron 表达式
□ 实现备份逻辑
□ 验证定时执行
```

### 任务 5: 完整项目（60 分钟）
```
□ 构建 Todo API
□ 集成 DynamoDB
□ 实现 CRUD
□ 前端测试
```

---

## 7.11 常见问题 FAQ

### Q1: Lambda 最长执行多久？
**A**: 15 分钟。超过需用其他服务（如 ECS）。

### Q2: 如何上传依赖包？
**A**: 
1. 本地打包 zip
2. 包含依赖
3. 上传到 Lambda
或使用 Lambda Layer

### Q3: 冷启动是什么？
**A**: 首次调用的延迟。优化方法：
- 使用 Provisioned Concurrency
- 减少包大小
- 选择更快的运行时

### Q4: Lambda 可以访问 VPC 吗？
**A**: 可以，需配置 VPC、子网和安全组。

### Q5: 如何本地测试？
**A**: 使用 SAM CLI 或 Docker 模拟。

### Q6: 函数之间如何通信？
**A**: 通过 SQS、SNS 或直接调用。

### Q7: 最大代码包多大？
**A**: 
- 上传：50MB（zip），250MB（解压）
- S3: 50MB（zip），750MB（解压）

---

## 7.12 下一步

恭喜你完成第七章！

现在你已经：
- ✅ 理解了无服务器概念
- ✅ 会创建 Lambda 函数
- ✅ 掌握了多种触发器
- ✅ 能构建 Serverless 应用
- ✅ 了解性能优化技巧

**接下来**:
请打开 **[08-IAM 权限管理.md](./08-IAM 权限管理.md)**

学习身份和访问管理：
- IAM 用户和组
- 策略和权限
- 角色和联合
- 安全最佳实践

---

## 💡 小贴士

> "无服务器是云计算的未来。Lambda 让你专注于业务逻辑而不是基础设施。记住：函数要小而精，单一职责，这样才容易维护和调试！"

**进阶学习**:
1. Step Functions 工作流
2. AppSync GraphQL
3. EventBridge 事件总线
4. Fargate 容器无服务器
5. Amplify 全栈开发

继续加油！你已经掌握了现代云架构的核心技能！🚀
