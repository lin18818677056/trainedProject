# Java热门面试题200道

## 1. 说说 Java 中 HashMap 的原理？

### 简述

HashMap 是 Java 中最常用的数据结构之一，它基于哈希表实现，用于存储键值对(key-value)。HashMap 允许使用 null 值和一个 null 键，是非同步的，不保证映射的顺序。

### 底层数据结构

HashMap 的底层实现经历了几个版本的变化：

1. **JDK 1.7 及以前**：数组 + 链表
2. **JDK 1.8 及以后**：数组 + 链表 + 红黑树

当链表长度超过一定阈值（默认为8）且数组长度大于64时，链表会转换为红黑树，以提高查找效率。

### 核心字段

- **table**：存储元素的数组，JDK 1.8 中类型为 Node<K,V>[]
- **size**：HashMap 中存储的键值对数量
- **threshold**：扩容阈值，当 size 超过 threshold 时会进行扩容
- **loadFactor**：负载因子，默认为 0.75，用于计算 threshold（threshold = capacity * loadFactor）

### 工作原理

#### 1. 存储机制

当向 HashMap 中添加元素时，会执行以下步骤：

1. 对 key 的 hashCode 值进行扰动计算（hash 函数）
2. 通过 (n - 1) & hash 计算元素在数组中的索引位置
3. 如果该位置没有元素，则直接插入
4. 如果该位置有元素（发生哈希冲突）：
   - JDK 1.7：采用头插法插入链表
   - JDK 1.8：采用尾插法，并在链表长度超过阈值时转换为红黑树

#### 2. 扰动函数

JDK 1.8 中的 hash 函数：
```
java 
static final int hash(Object key) {
 int h; 
 return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16); 
}
```

通过将 hashCode 的高16位与低16位进行异或运算，增加低位的随机性，减少哈希冲突。

#### 3. 初始化与扩容

- **初始化**：默认容量为16，负载因子为0.75
- **扩容**：当元素数量超过 threshold 时，容量扩大为原来的2倍
- 扩容时需要重新计算每个元素的索引位置

### 常见操作的时间复杂度

- **查找**：平均 O(1)，最坏 O(n)
- **插入**：平均 O(1)，最坏 O(n)
- **删除**：平均 O(1)，最坏 O(n)

在理想情况下（哈希函数均匀分布），时间复杂度为 O(1)；在最坏情况下（所有元素都发生哈希冲突），退化为链表操作，时间复杂度为 O(n)。

### JDK 1.7 与 JDK 1.8 的区别

| 特性 | JDK 1.7 | JDK 1.8 |
|------|---------|---------|
| 数据结构 | 数组+链表 | 数组+链表+红黑树 |
| 链表插入方式 | 头插法 | 尾插法 |
| 扩容时元素迁移 | 逐个迁移 | 按位分组迁移 |
| 哈希冲突解决 | 链表法 | 链表法+红黑树 |

### 线程安全性

HashMap 是非线程安全的，在多线程环境下可能会出现以下问题：

1. **数据不一致**：多个线程同时修改 HashMap 可能导致数据丢失
2. **死循环**：JDK 1.7 中扩容时采用头插法可能导致链表形成环形结构，造成死循环

如果需要线程安全的 Map，可以使用：
- **Collections.synchronizedMap()**
- **ConcurrentHashMap**

## 源码分析

### 核心内部类

#### Node<K,V> 节点类（链表节点）

```
java static class Node<K,V> implements Map.Entry<K,V> {
 final int hash;
 final K key; 
 V value; 
 Node<K,V> next;
 Node(int hash, K key, V value, Node<K,V> next) {
       this.hash = hash;
       this.key = key;
       this.value = value;
       this.next = next;
 }

// ... 其他方法
}
```
#### TreeNode<K,V> 红黑树节点类
```
java 
static final class TreeNode<K,V> extends LinkedHashMap.Entry<K,V> {
 TreeNode<K,V> parent;
  // 红黑树父节点 
 TreeNode<K,V> left;
  // 红黑树左子节点 
 TreeNode<K,V> right; 
 // 红黑树右子节点 
 TreeNode<K,V> prev; 
 // 链表前驱节点 
 boolean red; 
 // 颜色属性
 TreeNode(int hash, K key, V val, Node<K,V> next) {
       super(hash, key, val, next);
 }

// ... 红黑树相关操作方法
}
```
### 核心方法源码分析

#### hash() 方法
```
java static final int hash(Object key) {
 int h; 
 return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16); 
}


```
该方法通过将 hashCode 的高16位与低16位进行异或运算，使得哈希值的高位变化也能影响到低位，从而减少哈希冲突。

#### put() 方法
```
java 
public V put(K key, V value) { return putVal(hash(key), key, value, false, true); }
final V putVal(int hash, K key, V value, boolean onlyIfAbsent, boolean evict) { Node<K,V>[] tab; Node<K,V> p; int n, i; // 如果table为空或者长度为0，则进行初始化 if ((tab = table) == null || (n = tab.length) == 0) n = (tab = resize()).length; // 如果对应索引位置没有元素，直接插入新节点 if ((p = tab[i = (n - 1) & hash]) == null) tab[i] = newNode(hash, key, value, null); else { Node<K,V> e; K k; // 如果第一个节点就是要找的节点，则直接覆盖 if (p.hash == hash && ((k = p.key) == key || (key != null && key.equals(k)))) e = p; // 如果是红黑树节点 else if (p instanceof TreeNode) e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value); else { // 遍历链表 for (int binCount = 0; ; ++binCount) { // 到达链表末尾，插入新节点 if ((e = p.next) == null) { p.next = newNode(hash, key, value, null); // 如果链表长度超过阈值，转换为红黑树 if (binCount >= TREEIFY_THRESHOLD - 1) treeifyBin(tab, hash); break; } // 找到相同key的节点，跳出循环 if (e.hash == hash && ((k = e.key) == key || (key != null && key.equals(k)))) break; p = e; } } // 如果找到了相同key的节点，更新value if (e != null) { V oldValue = e.value; if (!onlyIfAbsent || oldValue == null) e.value = value; afterNodeAccess(e); return oldValue; } } ++modCount; // 如果size超过阈值，进行扩容 if (++size > threshold) resize(); afterNodeInsertion(evict); return null; }


```
#### get() 方法
```
java 
public V get(Object key) {
        Node<K, V> e;
        return (e = getNode(hash(key), key)) == null ? null : e.value;
}

final Node<K, V> getNode(int hash, Object key) {
        Node<K, V>[] tab;
        Node<K, V> first, e;
        int n;
        K k;
        if ((tab = table) != null && (n = tab.length) > 0 && (first = tab[(n - 1) & hash]) != null) {
            // 检查第一个节点是否匹配 
            if (first.hash == hash && ((k = first.key) == key || (key != null && key.equals(k)))) return first;
            // 遍历链表或红黑树
            if ((e = first.next) != null) {
                // 如果是红黑树节点 
                if (first instanceof TreeNode) return ((TreeNode<K, V>) first).getTreeNode(hash, key);
                // 遍历链表 
                do {
                    if (e.hash == hash && ((k = e.key) == key || (key != null && key.equals(k)))) return e;
                } while ((e = e.next) != null);
            }
        }
        return null;
}
```
#### resize() 扩容方法
```
java 
final Node<K,V>[] resize() { Node<K,V>[] oldTab = table; int oldCap = (oldTab == null) ? 0 : oldTab.length; int oldThr = threshold; int newCap, newThr = 0;
if (oldCap > 0) {
    // 如果容量已达最大值，不再扩容
    if (oldCap >= MAXIMUM_CAPACITY) {
        threshold = Integer.MAX_VALUE;
        return oldTab;
    }
    // 容量和阈值都扩大为原来的2倍
    else if ((newCap = oldCap << 1) < MAXIMUM_CAPACITY &&
             oldCap >= DEFAULT_INITIAL_CAPACITY)
        newThr = oldThr << 1;
}
else if (oldThr > 0)
    newCap = oldThr;
else {
    // 使用默认值初始化
    newCap = DEFAULT_INITIAL_CAPACITY;
    newThr = (int)(DEFAULT_LOAD_FACTOR * DEFAULT_INITIAL_CAPACITY);
}

if (newThr == 0) {
    float ft = (float)newCap * loadFactor;
    newThr = (newCap < MAXIMUM_CAPACITY && ft < (float)MAXIMUM_CAPACITY ?
              (int)ft : Integer.MAX_VALUE);
}
threshold = newThr;

// 创建新数组
@SuppressWarnings({"rawtypes","unchecked"})
Node<K,V>[] newTab = (Node<K,V>[])new Node[newCap];
table = newTab;

// 如果旧数组不为空，需要迁移元素
if (oldTab != null) {
    for (int j = 0; j < oldCap; ++j) {
        Node<K,V> e;
        if ((e = oldTab[j]) != null) {
            oldTab[j] = null;
            // 如果只有一个节点，直接迁移
            if (e.next == null)
                newTab[e.hash & (newCap - 1)] = e;
            // 如果是红黑树节点
            else if (e instanceof TreeNode)
                ((TreeNode<K,V>)e).split(this, newTab, j, oldCap);
            // 如果是链表节点
            else {
                Node<K,V> loHead = null, loTail = null;
                Node<K,V> hiHead = null, hiTail = null;
                Node<K,V> next;
                do {
                    next = e.next;
                    // 根据hash值的某一位是0还是1，将原链表分为两个链表
                    if ((e.hash & oldCap) == 0) {
                        if (loTail == null)
                            loHead = e;
                        else
                            loTail.next = e;
                        loTail = e;
                    }
                    else {
                        if (hiTail == null)
                            hiHead = e;
                        else
                            hiTail.next = e;
                        hiTail = e;
                    }
                } while ((e = next) != null);
                
                // 将低位链表放在原位置
                if (loTail != null) {
                    loTail.next = null;
                    newTab[j] = loHead;
                }
                // 将高位链表放在原位置+oldCap位置
                if (hiTail != null) {
                    hiTail.next = null;
                    newTab[j + oldCap] = hiHead;
                }
            }
        }
    }
}
return newTab;
}

```
## 扩展问题

### 1. 为什么 HashMap 的容量必须是 2 的幂次方？

HashMap 的容量必须是 2 的幂次方主要有以下原因：

1. **优化寻址算法**：当容量为 2 的幂次方时，(n-1) 的二进制表示是前面全为 0，后面全为 1 的形式。这样在进行 hash&(n-1) 运算时，可以保证计算结果均匀分布在数组的各个位置，减少哈希冲突。

2. **位运算效率高**：hash&(n-1) 比 hash%n 在性能上更优，因为位运算比取模运算快得多。

3. **扩容时元素迁移优化**：在扩容时，元素要么在原位置，要么在原位置+原容量的位置，可以通过 hash&oldCap 来判断，无需重新计算位置。

### 2. 为什么加载因子是 0.75？

加载因子是时间和空间成本的折中：

1. **空间利用率**：加载因子越大，空间利用率越高，但哈希冲突的概率越大，查找效率降低。
2. **查找效率**：加载因子越小，哈希冲突越少，查找效率越高，但空间利用率降低。
3. **经验值**：0.75 是大量的实验统计得出的较优值，既能保证较高的空间利用率，又能维持较好的查找效率。

### 3. 为什么链表转红黑树的阈值是 8？

1. **泊松分布**：根据泊松分布的概率计算，在负载因子为 0.75 的情况下，链表长度达到 8 的概率非常小（小于千万分之一），几乎不可能发生。
2. **时间和空间的权衡**：红黑树的查找时间复杂度是 O(logn)，链表是 O(n)。当链表长度达到 8 时，两者的性能差异已经比较明显。
3. **转换成本**：链表转红黑树需要额外的开销，只有在链表足够长时，这种开销才是值得的。

### 4. 为什么 HashMap 线程不安全？

HashMap 线程不安全主要体现在以下几个方面：

1. **数据不一致**：多个线程同时 put 数据时，可能导致数据丢失。
2. **扩容死循环**：JDK 1.7 中扩容时采用头插法，在多线程环境下可能导致链表形成环形结构，造成死循环。
3. **size 不准确**：size 字段没有使用 volatile 修饰，多线程环境下可能获取到不准确的值。

### 5. HashMap 性能优化建议

1. **预设初始容量**：如果能预估数据量，应设置合适的初始容量，避免频繁扩容。

```
java 
Map<String, String> map = new HashMap<>(1024);
```
2. **选择合适的 key 类型**：
   - 使用不可变对象作为 key
   - 重写 hashCode 和 equals 方法
   - String、Integer 等包装类是很好的选择

3. **避免哈希冲突**：
   - 确保 key 的 hashCode 方法能生成均匀分布的哈希值
   - 必要时可以自定义哈希函数

4. **使用线程安全的替代方案**：
   - 多线程环境下使用 ConcurrentHashMap
   - 或者使用 Collections.synchronizedMap()

### 6. 常见面试追问

#### Q: ConcurrentHashMap 是如何保证线程安全的？

A: JDK 1.7 中使用分段锁（Segment），JDK 1.8 中使用 CAS + synchronized 来保证线程安全。

#### Q: HashMap 中 key 为 null 是如何处理的？

A: HashMap 允许 key 为 null，且最多只能有一个。key 为 null 的元素存储在数组索引为 0 的位置。

#### Q: 为什么红黑树转回链表的阈值是 6 而不是 8？

A: 中间值 6 可以防止频繁的转换操作。如果也是 8，当链表长度在 8 附近波动时，会发生频繁的树化和链表化操作。

#### Q: HashMap 在 Java 8 中做了哪些优化？

A: 
1. 引入红黑树优化链表过长的问题
2. 优化扩容机制，元素迁移更加高效
3. 改进哈希函数，减少哈希冲突
4. 链表插入方式改为尾插法，避免扩容时的死循环问题

### 总结

HashMap 是 Java 中最重要的数据结构之一，理解其底层原理对性能优化和问题排查非常重要。在实际使用中需要注意：

1. 合理设置初始容量和负载因子
2. 选择合适的 key 类型（需要重写 hashCode 和 equals 方法）
3. 在多线程环境下使用线程安全的替代方案
4. 理解其底层实现原理，有助于写出更高效的代码

























