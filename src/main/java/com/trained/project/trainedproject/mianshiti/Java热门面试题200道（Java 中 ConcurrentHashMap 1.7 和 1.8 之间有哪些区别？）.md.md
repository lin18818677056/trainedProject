

**Java 中 ConcurrentHashMap 1.7 和 1.8 之间有哪些区别？**

# Java热门面试题200道

## 2. Java 中 ConcurrentHashMap 1.7 和 1.8 之间有哪些区别？

### 简述

ConcurrentHashMap 是 Java 中线程安全的哈希表实现，它在 JDK 1.7 和 JDK 1.8 中有着显著不同的实现方式。JDK 1.7 使用分段锁（Segment）机制，而 JDK 1.8 则采用了 CAS + synchronized 的方式，同时引入了红黑树优化数据结构。

### 核心区别

#### 1. 数据结构

**JDK 1.7**：
- 采用分段锁（Segment）机制
- 整体结构为：Segment 数组 + HashEntry 数组 + 链表
- Segment 继承自 ReentrantLock，每个 Segment 独立加锁

**JDK 1.8**：
- 废弃了 Segment，采用与 HashMap 类似的结构
- 整体结构为：Node 数组 + 链表/红黑树
- 引入红黑树优化，当链表长度超过阈值（默认为8）时转换为红黑树

#### 2. 锁机制

**JDK 1.7**：
- 使用分段锁（Segment）
- 每个 Segment 独立加锁，不同 Segment 可以并发访问
- 默认 16 个 Segment，最多支持 16 个线程并发写入

**JDK 1.8**：
- 使用 CAS + synchronized
- 锁粒度细化到桶（bucket）级别
- 无冲突时使用 CAS 操作，有冲突时使用 synchronized 锁住链表或红黑树的头节点

#### 3. 并发度

**JDK 1.7**：
- 并发度受 Segment 数量限制，默认为 16
- 最多支持与 Segment 数量相等的线程并发写入

**JDK 1.8**：
- 并发度不再受固定 Segment 数量限制
- 理论上支持与桶数量相等的线程并发写入

### 源码分析

#### JDK 1.7 核心结构


``` 
// Segment 结构
static final class Segment<K,V> extends ReentrantLock implements Serializable {
transient volatile HashEntry<K,V>[] table;
transient int count; // 元素数量
transient int modCount; // 修改次数
// ... 其他字段和方法
}
// HashEntry 结构
static final class HashEntry<K,V> {
final K key;
final int hash;
volatile V value;
final HashEntry<K,V> next;
// ... 其他字段和方法
}


```
#### JDK 1.8 核心结构

