# 第 8 章：IAM 权限管理详解

## 📖 本章目标
- 理解 IAM 的核心概念
- 学会创建和管理用户
- 掌握策略编写技巧
- 了解角色和联合身份
- 实践最小权限原则
- 配置安全审计和合规

---

## 8.1 IAM 基础概念

### 8.1.1 什么是 IAM？

**IAM = Identity and Access Management（身份和访问管理）**

简单理解：
```
IAM = 管理谁可以访问什么

核心问题:
  ✓ 谁可以使用 AWS 资源？（身份）
  ✓ 可以访问哪些资源？（授权）
  ✓ 可以进行什么操作？（权限）
```

### 8.1.2 IAM 核心组件

```
IAM
├── 身份 (Identities)
│   ├── 用户 (Users)
│   ├── 组 (Groups)
│   └── 角色 (Roles)
├── 访问管理
│   ├── 策略 (Policies)
│   └── 权限边界
└── 凭证
    ├── 密码
    ├── 访问密钥
    └── MFA 设备
```

### 8.1.3 IAM 重要特性

**全局服务**:
```
✓ 不受区域限制
✓ 配置对所有区域生效
✓ 数据全球复制
```

**免费使用**:
```
✓ IAM 本身不收费
✓ 只收取使用的资源费用
```

**最终一致性**:
```
✓ 更改可能需要时间传播
✓ 通常几秒到几分钟
✓ 不要立即测试刚修改的权限
```

---

## 8.2 IAM 用户管理

### 8.2.1 用户类型

**根用户 (Root User)**:
```
账户创建时的邮箱
拥有所有权限
应该严格保护
仅用于账户管理
```

**IAM 用户**:
```
你创建的普通用户
权限由策略定义
用于日常操作
可以有多个
```

### 8.2.2 创建用户（详细步骤）

#### 步骤 1: 进入 IAM 控制台
```
1. AWS 控制台搜索 "IAM"
2. 点击进入 IAM 服务
```

#### 步骤 2: 添加用户
```
1. 左侧菜单：用户
2. 点击 "添加用户"
```

#### 步骤 3: 设置用户详情

```
用户名：developer-zhang
  - 唯一标识
  - 不能包含空格
  
访问类型:
  ☑ 编程访问
    - Access Key for CLI/SDK
    
  ☑ 控制台访问
    - 密码登录 AWS 控制台
    
密码选项:
  ○ 自动生成密码
  ● 自定义密码
    - MySecurePass123!
    
用户必须在新密码创建后更改它:
  ☐ 不勾选（学习用）
  ☑ 勾选（生产推荐）
```

#### 步骤 4: 设置权限

**方式一：直接附加策略**
```
选择：附加现有策略直接

常用策略:
  ☑ AdministratorAccess
    - 完全管理权限
    
  ☑ PowerUserAccess
    - 除 IAM 外的所有权限
    
  ☑ ReadOnlyAccess
    - 只读权限
```

**方式二：添加到组（推荐）**
```
1. 先创建组
2. 给组分配策略
3. 将用户加入组

好处:
  ✓ 批量管理
  ✓ 权限一致
  ✓ 易于审计
```

**方式三：复制现有用户**
```
选择已有用户
复制其权限设置
适合快速创建同类用户
```

#### 步骤 5: 添加标签（可选）
```
键值对元数据
用于组织和跟踪

示例:
  Department: Engineering
  Role: Developer
  CostCenter: IT-001
```

#### 步骤 6: 审核并创建
```
检查所有配置
点击 "创建用户"
```

#### 步骤 7: 下载凭证
```
⬇️ 下载 .csv 文件
包含:
  - 用户名
  - Access Key ID
  - Secret Access Key
  - 控制台登录链接
  
⚠️ 重要:
  - 立即历史
  - 安全保存
  - Secret Key 只显示一次
```

### 8.2.3 管理用户

**查看用户详情**:
```
IAM → 用户 → 选择用户

可以看到:
  - 所属组
  - 附加策略
  - 安全凭证
  - 登录活动
```

**修改用户**:
```
1. 选择用户
2. 操作 → 编辑
   
可修改:
  - 用户名
  - 访问类型
  - 密码
  - 标签
```

**删除用户**:
```
前提:
  ✓ 删除访问密钥
  ✓ 删除 MFA 设备
  ✓ 移除所有策略
  ✓ 退出所有组
  
然后:
  操作 → 删除
```

---

## 8.3 IAM 组和批量管理

### 8.3.1 创建组

#### 步骤
```
1. IAM → 用户组
2. 创建用户组

组名：Developers
  - 描述性名称
  
附加策略:
  选择：PowerUserAccess
  
创建
```

### 8.3.2 常见组结构

**按职能分组**:
```
Administrators
  - 系统管理员
  - AdministratorAccess

Developers  
  - 开发人员
  - PowerUserAccess

DataScientists
  - 数据科学家
  - 特定服务权限

ReadOnly
  - 审计/财务
  - ReadOnlyAccess
```

**按项目分组**:
```
ProjectA-Team
  - 项目 A 成员
  - ProjectA-Specific-Policy

ProjectB-Team
  - 项目 B 成员
  - ProjectB-Specific-Policy
```

### 8.3.3 管理组成员

**添加用户到组**:
```
1. 选择组
2. 用户标签
3. 添加用户
4. 选择用户
5. 添加
```

**从组移除用户**:
```
1. 选择组
2. 用户标签
3. 选择用户
4. 移除
```

**查看组的权限**:
```
1. 选择组
2. 权限标签
3. 查看所有附加策略
```

---

## 8.4 IAM 策略详解

### 8.4.1 策略结构

**JSON 格式**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "service:action",
      "Resource": "arn:aws:..."
    }
  ]
}
```

**关键元素**:

**Version（版本）**:
```
"2012-10-17" - 当前版本
"2008-10-17" - 旧版本（不推荐）
```

**Statement（语句）**:
```
策略的核心内容
可以有一个或多个语句
```

**Effect（效果）**:
```
"Allow" - 允许权限
"Deny"  - 拒绝权限

注意:
  - 默认所有未明确允许的都被拒绝
  - Deny 优先级高于 Allow
```

**Action（操作）**:
```
指定允许/拒绝的操作

格式:
  - service:operation
  - service:* (所有操作)
  - * (所有服务的所有操作)

示例:
  - ec2:StartInstances
  - s3:GetObject
  - logs:*
```

**Resource（资源）**:
```
指定操作适用的资源

ARN 格式:
  arn:aws:service:region:account-id:resource-type/resource-name

示例:
  - arn:aws:s3:::my-bucket
  - arn:aws:s3:::my-bucket/*
  - arn:aws:ec2:us-east-1:123456789012:instance/i-1234567890abcdef0
```

**Condition（条件，可选）**:
```
何时策略生效

示例:
  - IP 地址范围
  - 时间范围
  - MFA 验证
  - SSL 加密
```

### 8.4.2 常用策略示例

#### 示例 1: S3 完全访问
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::my-bucket",
        "arn:aws:s3:::my-bucket/*"
      ]
    }
  ]
}
```

#### 示例 2: EC2 只读访问
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:Get*"
      ],
      "Resource": "*"
    }
  ]
}
```

#### 示例 3: 限制 IP 访问
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:*",
      "Resource": "*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": "192.168.1.0/24"
        }
      }
    }
  ]
}
```

#### 示例 4: 需要 MFA
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:DeleteObject",
      "Resource": "arn:aws:s3:::bucket/*",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
```

#### 示例 5: 工作时间访问
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "NumericLessThan": {
          "aws:CurrentHour": "18"
        },
        "NumericGreaterThan": {
          "aws:CurrentHour": "9"
        }
      }
    }
  ]
}
```

### 8.4.3 创建自定义策略

#### 步骤 1: 进入策略页面
```
IAM → 策略
```

#### 步骤 2: 创建策略
```
点击 "创建策略"
```

#### 步骤 3: 选择服务
```
可视化编辑器:
  选择服务：S3
  
操作级别:
  ☑ 读取
  ☑ 写入
  ☑ 列表
  
自动填充资源 ARN
```

#### 步骤 4: JSON 编辑器
```
切换到 JSON 标签
手动编写策略
  
高级功能:
  - 导入托管策略
  - 策略验证
  - 语法高亮
```

#### 步骤 5: 审核策略
```
名称：Custom-S3-Policy
描述：允许访问特定 S3 存储桶

审核:
  - 检查语法
  - 查看访问顾问
  - 策略使用率
```

#### 步骤 6: 创建
```
点击 "创建策略"
```

### 8.4.4 策略评估逻辑

**评估流程**:
```
1. 默认拒绝所有
2. 检查是否有显式拒绝（Deny）
   - 有 → 拒绝
   - 无 → 继续
3. 检查是否有显式允许（Allow）
   - 有 → 允许
   - 无 → 拒绝
```

**权限继承**:
```
用户权限 = 
  直接附加的策略 +
  所属组的策略 +
  角色策略（如果扮演角色）
```

**Deny 优先**:
```
即使有 Allow，只要有 Deny 就拒绝
```

---

## 8.5 IAM 角色

### 8.5.1 什么是角色？

**角色 vs 用户**:

| 特性 | 用户 | 角色 |
|------|------|------|
| 长期凭证 | 有 | 无 |
| 关联实体 | 人/应用 | 任何人/服务 |
| 临时凭证 | 无 | 有 |
| 数量限制 | 5000 | 1000 |

**角色用途**:
```
✓ EC2 实例访问其他 AWS 服务
✓ 跨账户访问
✓ 联合身份（SSO）
✓ 临时提升权限
```

### 8.5.2 创建 EC2 角色

#### 场景：让 EC2 访问 S3

**步骤 1: 创建角色**
```
1. IAM → 角色
2. 创建角色

受信任实体类型:
  ☑ AWS 服务
  
用例:
  选择：EC2
  
下一步
```

**步骤 2: 添加权限**
```
附加策略:
  ☑ AmazonS3ReadOnlyAccess
  
或其他 S3 相关策略

下一步
```

**步骤 3: 命名**
```
名称：EC2-S3-Read-Role
描述：允许 EC2 读取 S3 存储桶

创建角色
```

**步骤 4: 附加到 EC2**
```
1. EC2 控制台
2. 选择实例
3. 操作 → 安全
4. 修改 IAM 角色
5. 选择刚创建的角色
6. 更新
```

**步骤 5: 测试**
```bash
# 在 EC2 上执行
aws s3 ls

# 无需配置凭证
# 自动使用角色临时凭证
```

### 8.5.3 跨账户角色

**场景**: 账户 A 的用户访问账户 B 的资源

**账户 B 配置（被访问方）**:
```
1. 创建角色
2. 可信实体类型：另一个 AWS 账户
3. 输入账户 A 的 ID
4. 附加权限策略
5. 创建角色
```

**信任策略示例**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111122223333:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

**账户 A 配置（访问方）**:
```
1. 创建用户或角色
2. 附加策略允许 AssumeRole

策略:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::444455556666:role/CrossAccountRole"
    }
  ]
}
```

**切换角色**:
```bash
# CLI 方式
aws sts assume-role \
  --role-arn arn:aws:iam::444455556666:role/CrossAccountRole \
  --role-session-name MySession

# 返回临时凭证
# AccessKeyId, SecretAccessKey, SessionToken
```

### 8.5.4 使用临时凭证

**控制台切换角色**:
```
1. 点击右上角账户
2. 切换角色
3. 输入:
   - 账户 ID
   - 角色名称
4. 切换
```

**CLI 使用临时凭证**:
```bash
# 设置环境变量
export AWS_ACCESS_KEY_ID=ASIA...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...

# 现在可以使用临时凭证执行操作
aws s3 ls
```

---

## 8.6 安全最佳实践

### 8.6.1 根账户保护

**必须做的**:
```
✓ 启用 MFA（最重要！）
✓ 不使用根账户进行日常操作
✓ 删除根账户的访问密钥
✓ 定期更改密码
✓ 监控根账户活动
```

**检查清单**:
```bash
# 检查是否启用了 MFA
aws iam get-account-summary

# 检查根账户访问密钥
aws iam list-access-keys \
  --user-name root
```

### 8.6.2 最小权限原则

**实施方法**:
```
1. 从最小权限开始
2. 根据需要逐步增加
3. 定期审查和清理
4. 使用权限边界限制最大权限
```

**权限分析工具**:
```
IAM → 用户 → 访问顾问

查看:
  - 哪些服务被使用
  - 最后一次访问时间
  - 未使用的权限
```

### 8.6.3 凭证轮换

**推荐周期**:
```
访问密钥：90 天
密码：90 天
MFA 设备：电池耗尽时更换
```

**自动化轮换**:
```python
import boto3

iam = boto3.client('iam')

# 创建新的访问密钥
response = iam.create_access_key(UserName='username')

# 通知用户更新配置
# ...

# 等待一段时间后删除旧密钥
iam.delete_access_key(
    UserName='username',
    AccessKeyId='OLD_KEY_ID'
)
```

### 8.6.4 多因素认证 (MFA)

**强制 MFA 策略**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ForceMFA",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }
  ]
}
```

**MFA 设备类型**:
```
虚拟 MFA 设备:
  - Google Authenticator
  - Microsoft Authenticator
  - 免费
  
硬件 MFA 设备:
  - YubiKey
  - AWS 官方 MFA 密钥
  - 需购买
  
U2F 安全密钥:
  - 支持 FIDO 标准
  - 更便捷
```

### 8.6.5 密码策略

**配置强密码策略**:
```
IAM → 账户设置 → 密码策略

建议配置:
  ☑ 至少一个小写字母
  ☑ 至少一个大写字母
  ☑ 至少一个数字
  ☑ 至少一个非字母数字字符
  ☑ 最少 8 个字符
  ☑ 禁止与用户名相同
  ☑ 阻止密码重用（最近 3 次）
  
密码有效期：90 天
宽限期：7 天
```

---

## 8.7 审计和合规

### 8.7.1 CloudTrail 审计

**启用 CloudTrail**:
```
1. CloudTrail 控制台
2. 创建跟踪
3. 名称：management-trail
4. 跟踪类型：所有区域
5. 记录以下管理事件:
   ☑ 读取
   ☑ 写入
6. 创建
```

**查看审计日志**:
```
CloudTrail → 事件历史记录

可以查看:
  - 谁做了什么操作
  - 什么时间
  - 从哪个 IP
  - 操作结果
```

**S3 存储日志**:
```
长期存储 CloudTrail 日志
便于分析和合规
```

### 8.7.2 IAM Access Analyzer

**功能**:
```
识别共享给外部的资源
分析资源策略
发现意外访问
```

**启用**:
```
IAM → Access Analyzer
创建分析器
```

### 8.7.3 Security Hub

**集中安全视图**:
```
聚合所有安全告警
检查合规状态
提供修复建议
```

---

## 8.8 常见问题排查

### 问题 1: Access Denied

**排查步骤**:
```
1. 检查用户是否有权限
2. 查看附加的策略
3. 检查组 membership
4. 检查是否有 Deny 语句
5. 查看 CloudTrail 日志
6. 使用策略模拟器测试
```

**使用策略模拟器**:
```
IAM → 策略 → 策略模拟器

选择:
  - 用户/角色
  - 操作
  - 资源
  
测试权限
```

### 问题 2: 无法切换角色

**检查**:
```
□ 信任策略是否正确
□ 账户 ID 是否正确
□ 角色名称是否正确
□ 是否有 AssumeRole 权限
□ MFA 是否必需
```

### 问题 3: 权限不生效

**原因**:
```
- 最终一致性延迟
- 策略语法错误
- 资源 ARN 不匹配
- 条件不满足
- 服务不支持
```

**解决**:
```
1. 等待几分钟
2. 验证策略 JSON
3. 检查 ARN 格式
4. 查看条件表达式
5. 确认服务支持
```

---

## 8.9 实用工具和技巧

### 8.9.1 AWS CLI 凭证管理

**配置文件**:
```bash
# ~/.aws/credentials
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[profile dev]
aws_access_key_id = AKIAI44QH8DHBEXAMPLE
aws_secret_access_key = je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
```

**使用不同 profile**:
```bash
# 使用 default
aws s3 ls

# 使用 dev profile
aws s3 ls --profile dev
```

### 8.9.2 凭证轮换脚本

```bash
#!/bin/bash

USERNAME="developer-zhang"

# 创建新密钥
NEW_KEY=$(aws iam create-access-key \
  --user-name $USERNAME \
  --query 'AccessKey.{AccessKeyId:AccessKeyId,SecretAccessKey:SecretAccessKey}' \
  --output json)

echo "新密钥已创建:"
echo "$NEW_KEY"

# 提示更新配置
echo "请更新 ~/.aws/credentials 文件"

# 等待确认后删除旧密钥
read -p "更新完成后按回车删除旧密钥..."

# 列出所有密钥
aws iam list-access-keys --user-name $USERNAME

# 删除旧密钥
OLD_KEY_ID="AKIA..."
aws iam delete-access-key \
  --user-name $USERNAME \
  --access-key-id $OLD_KEY_ID
```

### 8.9.3 批量用户管理

```python
import boto3

iam = boto3.client('iam')

# 批量创建用户
users = ['dev1', 'dev2', 'dev3']
group_name = 'Developers'

for username in users:
    # 创建用户
    iam.create_user(UserName=username)
    
    # 添加到组
    iam.add_user_to_group(
        UserName=username,
        GroupName=group_name
    )
    
    print(f"Created user: {username}")
```

---

## 8.10 学习检查清单

### ✅ 理论知识
- [ ] 理解 IAM 的核心概念
- [ ] 知道用户、组、角色的区别
- [ ] 明白策略的结构和语法
- [ ] 了解权限评估逻辑

### ✅ 实践技能
- [ ] 成功创建 IAM 用户
- [ ] 配置了组和批量管理
- [ ] 编写了自定义策略
- [ ] 创建了 EC2 角色
- [ ] 实现了跨账户访问

### ✅ 安全检查
- [ ] 根账户启用了 MFA
- [ ] 实施了最小权限
- [ ] 配置了强密码策略
- [ ] 启用了 CloudTrail
- [ ] 定期审查权限

---

## 8.11 实践任务

### 任务 1: 创建开发团队（30 分钟）
```
□ 创建 Developers 组
□ 附加 PowerUserAccess 策略
□ 创建 3 个开发用户
□ 全部加入组
```

### 任务 2: 自定义 S3 策略（30 分钟）
```
□ 创建只访问特定桶的策略
□ 限制只能从公司 IP 访问
□ 测试权限是否生效
□ 验证限制条件
```

### 任务 3: EC2 角色配置（30 分钟）
```
□ 创建 EC2 访问 S3 的角色
□ 附加到运行中的实例
□ 测试无需凭证访问 S3
□ 验证角色权限
```

### 任务 4: 跨账户访问（40 分钟）
```
□ 创建第二个 AWS 账户
□ 配置跨账户角色
□ 测试角色切换
□ 验证资源访问
```

### 任务 5: 安全加固（30 分钟）
```
□ 配置强密码策略
□ 强制 MFA
□ 启用 CloudTrail
□ 审查现有权限
```

---

## 8.12 常见问题 FAQ

### Q1: IAM 用户数量有限制吗？
**A**: 每个账户最多 5000 个 IAM 用户。

### Q2: 策略多大算复杂？
**A**: 单个策略最大 6144 个字符。建议拆分小策略。

### Q3: 如何撤销误授的权限？
**A**: 
1. 立即删除或修改策略
2. 检查 CloudTrail 审计
3. 如有泄露，轮换所有凭证

### Q4: 角色可以链式扮演吗？
**A**: 不可以。角色 A 不能扮演角色 B。

### Q5: 临时凭证多久过期？
**A**: 默认 1 小时，最长 12 小时。

### Q6: 如何查看谁有访问权限？
**A**: 使用 IAM Access Analyzer 或策略模拟器。

### Q7: 删除用户需要注意什么？
**A**: 
1. 删除所有访问密钥
2. 删除 MFA 设备
3. 移除所有策略
4. 退出所有组
5. 删除内联策略

---

## 8.13 下一步

恭喜你完成第八章！

现在你已经：
- ✅ 掌握了 IAM 核心概念
- ✅ 会管理用户和组
- ✅ 能编写自定义策略
- ✅ 了解角色和跨账户访问
- ✅ 实施安全最佳实践

**接下来**:
请打开 **[09-实战项目.md](./09-实战项目.md)**

综合运用所学知识：
- 完整 Web 应用部署
- 微服务架构实现
- 自动化 CI/CD 管道
- 监控和告警配置

---

## 💡 小贴士

> "IAM 是 AWS 安全的基石。正确的权限管理能防止 90% 以上的安全事故。记住：永远从最小权限开始，按需授予，定期审查！"

**进阶学习**:
1. Organizations 多账户管理
2. Control Tower 治理
3. Single Sign-On (SSO)
4. Resource Access Manager
5. Certificate Manager

继续加油！你已经掌握了企业级云安全的核心技能！🚀
