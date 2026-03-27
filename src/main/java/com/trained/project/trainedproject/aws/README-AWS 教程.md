# AWS 学习资源汇总

## 📚 完整教程目录

本 AWS 云服务学习教程共包含 **10 个章节**，涵盖从入门到实战的完整内容。

---

## 📖 章节导航

### [第 0 章：学习路线图](./00-学习路线图.md)
- 整体学习规划
- 学习时间建议
- 费用控制提醒
- 安全注意事项

### [第 1 章：AWS 基础概念](./01-AWS 基础概念.md)
- 什么是 AWS 和云计算
- 三种服务模式（IaaS/PaaS/SaaS）
- AWS 核心优势
- 主要服务概览
- 定价模型和免费套餐

### [第 2 章：AWS 账户设置](./02-AWS 账户设置.md)
- 详细注册步骤
- MFA 多因素认证配置
- 账单和预算告警设置
- IAM 用户创建
- CLI 工具配置

### [第 3 章：EC2 计算服务](./03-EC2 计算服务.md)
- EC2 核心概念
- AMI 和实例类型
- 创建和管理实例
- 多种连接方式
- Web 应用部署实战
- 监控和故障排查

### [第 4 章：S3 存储服务](./04-S3 存储服务.md)
- 对象存储基础
- 存储桶管理
- 文件上传下载
- 存储类别选择
- 静态网站托管
- 版本控制和生命周期

### [第 5 章：RDS 数据库服务](./05-RDS 数据库服务.md)
- 关系型数据库服务
- MySQL 实例创建
- 数据库连接操作
- 自动备份恢复
- 高可用架构
- 性能优化技巧

### [第 6 章：VPC 网络服务](./06-VPC 网络服务.md)
- 虚拟私有云概念
- 子网划分和路由
- NAT 网关配置
- 安全组和 NACL
- Bastion Host 跳板机
- VPC 对等连接

### [第 7 章：Lambda 无服务器](./07-Lambda 无服务器.md)
- 无服务器计算基础
- Lambda 函数创建
- 事件驱动架构
- API Gateway 集成
- S3 触发器
- Serverless 项目实战

### [第 8 章：IAM 权限管理](./08-IAM 权限管理.md)
- 身份和访问管理
- 用户和组管理
- 策略编写技巧
- 角色和跨账户访问
- 安全最佳实践
- 审计和合规

### [第 9 章：综合实战项目](./09-实战项目.md)
- 图片分享平台
- 完整架构设计
- 前后端开发
- 自动化部署
- 监控和运维
- 成本分析

### [第 10 章：最佳实践](./10-最佳实践.md)
- 成本优化全面指南
- 安全最佳实践
- 架构设计原则
- 运维自动化
- AWS 认证路径
- 持续学习建议

---

## 🎯 快速参考表

### 核心服务速查

| 服务 | 用途 | 关键特性 | 免费套餐 |
|------|------|----------|----------|
| **EC2** | 虚拟服务器 | 弹性扩展、按需付费 | 750 小时/月 t2.micro |
| **S3** | 对象存储 | 高可靠、无限扩展 | 5GB 标准存储 |
| **RDS** | 关系数据库 | 自动备份、易于管理 | 750 小时 db.t2.micro |
| **Lambda** | 无服务器 | 事件驱动、自动扩展 | 100 万次请求/月 |
| **VPC** | 虚拟网络 | 网络隔离、安全控制 | 免费 |
| **IAM** | 权限管理 | 细粒度权限、MFA | 免费 |
| **CloudFront** | CDN | 全球加速、低延迟 | 有一定免费额度 |
| **API Gateway** | API 管理 | RESTful、WebSocket | 100 万次调用/月 |
| **DynamoDB** | NoSQL 数据库 | 快速、可扩展 | 25GB 存储 |
| **CloudWatch** | 监控服务 | 指标、日志、告警 | 基本监控免费 |

### 常用端口

| 服务 | 端口 | 协议 |
|------|------|------|
| SSH | 22 | TCP |
| HTTP | 80 | TCP |
| HTTPS | 443 | TCP |
| MySQL | 3306 | TCP |
| PostgreSQL | 5432 | TCP |
| RDP (Windows) | 3389 | TCP |
| FTP | 21 | TCP |

### 重要命令行

```bash
# EC2 相关
aws ec2 describe-instances
aws ec2 start-instances --instance-ids i-xxx
aws ec2 stop-instances --instance-ids i-xxx

# S3 相关
aws s3 ls
aws s3 cp file.txt s3://bucket/
aws s3 sync ./local s3://bucket/

# RDS 相关
aws rds describe-db-instances
aws rds create-db-snapshot

# Lambda 相关
aws lambda invoke --function-name myFunc output.json

# IAM 相关
aws iam list-users
aws iam create-user --user-name newuser
```

---

## 💡 学习提示

### 新手常见误区

❌ **错误做法**:
1. 不设置预算告警
2. 使用根账户进行日常操作
3. 忘记关闭不用的实例
4. 安全组开放 0.0.0.0/0
5. 不启用 MFA
6. 把密钥文件放在桌面

✅ **正确做法**:
1. 立即设置预算告警（如$10）
2. 创建 IAM 用户，保护根账户
3. 每天检查运行中的资源
4. SSH 只开放给自己的 IP
5. 所有账户启用 MFA
6. 密钥文件加密保存

### 学习顺序建议

**第一周**: 
- 阅读第 1-2 章
- 完成账户注册
- 设置安全配置

**第二周**:
- 学习第 3 章 EC2
- 创建第一台服务器
- 部署简单应用

**第三周**:
- 学习第 4 章 S3
- 练习文件上传下载
- 尝试静态网站

**第四周**:
- 学习第 5 章 RDS
- 创建数据库
- 练习 SQL 操作

**第五周**:
- 学习第 6 章 VPC
- 搭建网络架构
- 配置安全组

**第六周**:
- 学习第 7 章 Lambda
- 创建无服务器函数
- 集成其他服务

**第七周**:
- 学习第 8 章 IAM
- 深入理解权限
- 配置复杂策略

**第八周及以后**:
- 完成第 9 章实战项目
- 综合运用所有知识
- 准备认证考试

---

## 🔗 有用的链接

### 官方资源
- [AWS 官网](https://aws.amazon.com/cn/)
- [AWS 文档中心](https://docs.aws.amazon.com/)
- [AWS 培训认证](https://aws.amazon.com/cn/training/)
- [AWS 支持中心](https://console.aws.amazon.com/support/)
- [AWS 白皮书](https://aws.amazon.com/cn/whitepapers/)
- [AWS 架构中心](https://aws.amazon.com/cn/architecture/)

### 学习平台
- [AWS Educate](https://aws.amazon.com/cn/education/awseducate/) - 学生资源
- [AWS Skill Builder](https://skillbuilder.aws/) - 免费在线学习
- [A Cloud Guru](https://acloudguru.com/) - 认证备考
- [Linux Academy](https://linuxacademy.com/) - 实践实验

### 工具和 SDK
- [AWS CLI](https://aws.amazon.com/cn/cli/) - 命令行工具
- [AWS SDKs](https://aws.amazon.com/cn/tools/) - 各语言 SDK
- [AWS Tools for PowerShell](https://aws.amazon.com/cn/powershell/)
- [AWS Toolkit for VS Code](https://aws.amazon.com/cn/visualstudio/)

### 社区和论坛
- [AWS re:Post](https://repost.aws/) - 官方问答社区
- [Stack Overflow - AWS 标签](https://stackoverflow.com/questions/tagged/amazon-web-services)
- [Reddit r/aws](https://www.reddit.com/r/aws/)
- [AWS 开发者论坛](https://forums.aws.amazon.com/)

### 中文资源
- [AWS 中国博客](https://www.amazonaws.cn/blogs/china/)
- [知乎 AWS 话题](https://www.zhihu.com/topic/19928023)
- [掘金 AWS 专栏](https://juejin.im/tag/AWS)
- [SegmentFault AWS 标签](https://segmentfault.com/t/aws)

---

## 📋 检查清单

### 学习前准备
- [ ] 准备好电子邮箱
- [ ] 准备好信用卡（Visa/MasterCard）
- [ ] 准备好手机号码
- [ ] 了解费用风险
- [ ] 承诺定期学习

### 每章完成后
- [ ] 完成所有章节练习
- [ ] 理解核心概念
- [ ] 能够实际操作
- [ ] 记录学习笔记
- [ ] 复习重点内容

### 实战项目检查
- [ ] 环境准备完成
- [ ] 基础设施搭建
- [ ] 后端代码开发
- [ ] 前端页面制作
- [ ] 部署和测试
- [ ] 监控配置
- [ ] 成本核算

### 认证备考
- [ ] 完成所有理论学习
- [ ] 做过往真题
- [ ] 参加模拟考试
- [ ] 预约考试时间
- [ ] 准备考试材料

---

## 🎓 学习成果检验

### 初级水平（完成 1-4 章）
```
✓ 理解 AWS 基础概念
✓ 能够创建 EC2 实例
✓ 会使用 S3 存储文件
✓ 了解基本的安全设置
✓ 可以部署简单应用
```

### 中级水平（完成 5-8 章）
```
✓ 掌握数据库服务
✓ 理解网络架构
✓ 会使用无服务器
✓ 能够配置复杂权限
✓ 可以设计小型系统
```

### 高级水平（完成 9-10 章）
```
✓ 完成完整项目
✓ 考虑成本优化
✓ 实施安全措施
✓ 自动化运维
✓ 准备专业认证
```

---

## 💰 费用估算

### 学习期间预计费用

**完全免费（12 个月内）**:
```
如果充分利用免费套餐:
- EC2 t2.micro: $0
- S3 5GB: $0
- RDS db.t2.micro: $0
- Lambda 100 万次：$0
- 总计：$0/月
```

**适度使用**:
```
偶尔超出免费套餐:
- 额外 EC2 使用：$5-10
- 额外 S3 存储：$1-2
- 数据传输：$2-5
- 总计：$8-17/月
```

** интенсивное 使用**:
```
频繁实验和项目:
- 各种服务使用：$20-50
- 生产级别测试：$50-100
- 总计：$20-100/月
```

### 省钱技巧
1. ⏰ 不用时立即停止实例
2. 📊 设置严格的预算告警
3. 🗑️ 及时清理闲置资源
4. 🌙 开发环境定时开关机
5. 📦 选择合适的存储类型
6. 🔄 利用预留实例（长期）

---

## 📞 获取帮助

### 遇到问题时
1. 先查阅 AWS 官方文档
2. 在 Stack Overflow 搜索
3. 查看 AWS re:Post 社区
4. 联系 AWS 支持（如有）
5. 向社区提问

### 常见问题 FAQ
详见各章节末尾的 FAQ 部分

---

## 🌟 成功故事

许多学习者通过这个系统化教程：
- ✅ 成功转行云计算行业
- ✅ 获得 AWS 认证
- ✅ 完成个人项目
- ✅ 提升职业技能
- ✅ 实现薪资增长

**下一个成功案例就是你！**

---

## 📅 学习计划模板

### 每日学习（建议 2 小时）
```
30 分钟：阅读理论
60 分钟：动手实践
20 分钟：记录笔记
10 分钟：复习总结
```

### 每周目标
```
完成 1-2 个章节
做完整章练习
总结学习心得
准备下周内容
```

### 每月回顾
```
复习已学内容
评估学习进度
调整学习计划
设定新目标
```

---

## 🎁 附加资源

### 视频教程推荐
- AWS 官方 YouTube 频道
- re:Invent 大会演讲
- AWS 技术讲座录像

### 书籍推荐
- 《AWS 解决方案架构师指南》
- 《AWS 开发者手册》
- 《云计算架构：AWS 实践》

### 播客推荐
- AWS Morning Matchup
- Cloud Academy Podcast
- This Week in Cloud

---

## ✨ 最后的话

学习 AWS 是一段精彩的旅程。这 10 个章节的教程为你提供了完整的知识体系，但真正的成长来自于持续的实践和学习。

**记住**:
- 每天都要进步一点点
- 不要害怕犯错
- 分享让你学得更快
- 坚持就是胜利

**祝你**:
- 学习愉快！📚
- 实践顺利！💻
- 认证成功！🏆
- 前程似锦！🚀

---

**开始你的 AWS 之旅吧！未来云架构师！✨**
