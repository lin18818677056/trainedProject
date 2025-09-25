

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


```  java
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

```java

public V put(K key, V value) {
    return putVal(key, value, false);
}
final V putVal(K key, V value, boolean onlyIfAbsent) {
    if (key == null || value == null) throw new NullPointerException();
    int hash = spread(key.hashCode());
    int binCount = 0;
    for (Node<K,V>[] tab = table;;) {
        Node<K,V> f; int n, i, fh;
        // 初始化 table
        if (tab == null || (n = tab.length) == 0)
            tab = initTable();
        // CAS 插入新节点
        else if ((f = tabAt(tab, i = (n - 1) & hash)) == null) {
            if (casTabAt(tab, i, null,new Node<K,V>(hash, key, value, null)))
                break;
        }
        // 扩容时的特殊处理
        else if ((fh = f.hash) == MOVED) {
            tab = helpTransfer(tab, f);
        }else {
            V oldVal = f.val;
            // 对头节点加 synchronized 锁
            synchronized (f) {
                if (tabAt(tab, i) == f) {
                    if (fh >= 0) {
                        binCount = 1;
                        for (Node<K,V> e = f;; ++binCount) {
                            K ek;
                            if (e.hash == hash && ((ek = e.key) == key || (ek != null && key.equals(ek)))) {
                                oldVal = e.val;
                                if (!onlyIfAbsent)
                                    e.val = value;
                                break;
                            }
                            Node<K,V> pred = e;
                            if ((e = e.next) == null) { 
                                pred.next = new Node<K,V>(hash, key, value, null);
                                break;
                            }
                        }
                    }else if (f instanceof TreeBin) {
                        Node<K,V> p; binCount = 2;
                        if ((p = ((TreeBin<K,V>)f).putTreeVal(hash, key, value)) != null) {
                            oldVal = p.val;
                            if (!onlyIfAbsent)
                                p.val = value;
                        }
                    }
                }
            }
            if (binCount != 0) {
                if (binCount >= TREEIFY_THRESHOLD)
                    treeifyBin(tab, i);
                if (oldVal != null)
                    return oldVal;
                break;
            }
        }
    }
    addCount(1L, binCount);
    return null;
}


```

### size 方法实现差异

**JDK 1.7**：
```    java 
public int size() { 
        // 先尝试不加锁统计 
        long n = sumCount();
        // 如果统计过程中有修改，则加锁重新统计 
        return (n < 0L) ? 0 : (n > (long)Integer.MAX_VALUE) ? Integer.MAX_VALUE : (int)n; }
// sumCount 方法 
/final long sumCount() { 
        // 两次尝试统计 
        // 如果两次统计期间有修改，则需要加锁统计 
        Segment<K,V>[] segments = this.segments; long sum = 0L;
        // 最多重试3次 
        for (int i = 0; i < segments.length; ++i) { 
            Segment<K,V> seg = segments[i]; 
            if (seg != null) {
                sum += seg.modCount;
            } sum += seg.count; 
        } 
    } 
    // 如果统计过程中有修改，则加锁重新统计 
    // ... 
    return sum; 
}
``` 

**JDK 1.8**：
```    java 

public int size() {
        long n = sumCount();
        return ((n < 0L) ? 0 : (n > (long) Integer.MAX_VALUE) ? Integer.MAX_VALUE : (int) n);
    }
    // 使用 baseCount 和 CounterCell 数组进行计数
    private transient volatile long baseCount;
    private transient volatile CounterCell[] counterCells;

    final long sumCount() {
        CounterCell[] as = counterCells;
        CounterCell a;
        long sum = baseCount;
        if (as != null) {
            for (int i = 0; i < as.length; ++i) {
                if ((a = as[i]) != null) sum += a.value;
            }
        }
        return sum;
    }


``` 

### 扩容机制差异

**JDK 1.7**：
- 扩容是按 Segment 进行的
- 每个 Segment 独立扩容
- 不支持并发扩容

**JDK 1.8**：
- 支持多线程并发扩容
- 引入了 ForwardingNode 节点标记正在迁移的桶
- 多个线程可以协助扩容，提高扩容效率

### 性能对比

| 特性 | JDK 1.7 | JDK 1.8 |
|------|---------|---------|
| 锁粒度 | Segment 级别（粗粒度） | Node 级别（细粒度） |
| 并发度 | 受 Segment 数量限制 | 理论上无限制 |
| 数据结构 | 数组 + 链表 | 数组 + 链表/红黑树 |
| 扩容机制 | Segment 独立扩容 | 支持并发协助扩容 |
| 读操作 | 通常无锁 | 完全无锁 |
| 写操作 | Segment 加锁 | CAS 或 synchronized |

### 扩展问题

#### 1. 为什么 JDK 1.8 要废弃 Segment？

1. **锁粒度更细**：Segment 锁粒度较粗，限制了并发性能
2. **结构更简单**：废弃 Segment 后结构更接近 HashMap，便于理解和维护
3. **更好的并发性能**：CAS + synchronized 的组合提供了更好的并发性能

#### 2. JDK 1.8 中为什么使用 synchronized 而不是 ReentrantLock？

1. **JVM 优化**：JVM 对 synchronized 有大量优化（偏向锁、轻量级锁等）
2. **性能相当**：在竞争不激烈的情况下，synchronized 性能与 ReentrantLock 相当
3. **代码简洁**：使用 synchronized 代码更简洁，不需要手动释放锁

#### 3. 为什么引入红黑树？

1. **性能优化**：当链表过长时，查找效率会下降到 O(n)
2. **时间复杂度**：红黑树的查找时间复杂度为 O(log n)
3. **阈值设置**：链表长度超过 8 且数组长度大于 64 时转换为红黑树

#### 4. ForwardingNode 的作用是什么？

1. **标记迁移**：标记正在迁移的桶
2. **协助扩容**：其他线程遇到 ForwardingNode 时可以协助扩容
3. **避免重复迁移**：防止多个线程重复迁移同一个桶

### 总结

ConcurrentHashMap 在 JDK 1.7 和 JDK 1.8 中的实现有显著差异：

1. **数据结构**：从 Segment + HashEntry 转变为 Node + 链表/红黑树
2. **锁机制**：从分段锁转变为 CAS + synchronized
3. **并发性能**：JDK 1.8 提供了更好的并发性能和更高的并发度
4. **扩容机制**：JDK 1.8 支持多线程并发扩容
5. **代码复杂度**：JDK 1.8 的实现更简洁，更易于维护

这些改进使得 ConcurrentHashMap 在高并发场景下有更好的性能表现。

