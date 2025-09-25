
**Java 中有哪些集合类？请简单介绍**

# Java热门面试题200道

## 5. Java 中有哪些集合类？请简单介绍


### 简述

Java集合框架是Java语言中非常重要的一部分，它提供了多种数据结构的实现，用于存储和操作一组对象。Java集合框架主要位于`java.util`包中，主要包括三大接口：Collection、Map和Iterator，以及它们的各种实现类。

### Java集合框架整体结构

Java集合框架主要分为两大体系：

1. **Collection接口体系**：用于存储单个对象的集合
2. **Map接口体系**：用于存储键值对（key-value）的映射

### Collection接口体系

Collection是所有单列集合的根接口，它又分为以下主要子接口：

#### 1. List接口
List接口是一个有序集合，允许重复元素，可以通过索引访问元素。

**主要实现类：**
- **ArrayList**：基于动态数组实现，查询快，增删慢，线程不安全
- **LinkedList**：基于双向链表实现，增删快，查询慢，线程不安全
- **Vector**：基于动态数组实现，线程安全，性能较低（已较少使用）
- **Stack**：继承自Vector，实现栈结构，后进先出（LIFO）

#### 2. Set接口
Set接口不允许重复元素，不保证元素的顺序（某些实现类除外）。

**主要实现类：**
- **HashSet**：基于HashMap实现，元素无序，允许null元素，线程不安全
- **LinkedHashSet**：基于 LinkedHashMap 实现，维护插入顺序
- **TreeSet**：基于红黑树实现，元素自然排序或自定义排序，不允许null元素

#### 3. Queue接口
Queue接口用于存储和操作临时数据，通常按照特定的规则进行元素的插入和移除。

**主要实现类：**
- **LinkedList**：实现了Queue接口，可作为队列使用
- **PriorityQueue**：优先级队列，按照元素的优先级进行排序
- **ArrayDeque**：双端队列，可用作栈或队列

### Map接口体系

Map接口存储键值对（key-value）映射关系，键不允许重复，值可以重复。

**主要实现类：**
- **HashMap**：基于哈希表实现，键值都可以为null，线程不安全
- **LinkedHashMap**：维护插入顺序或访问顺序的HashMap
- **TreeMap**：基于红黑树实现，按键排序，线程不安全
- **Hashtable**：线程安全的哈希表实现，键值都不能为null（已较少使用）
- **ConcurrentHashMap**：线程安全的HashMap，适用于高并发场景
- **Properties**：继承自Hashtable，用于处理属性文件

### 集合类的选择建议

#### 1. List选择
- **ArrayList**：适用于频繁查询、较少增删的场景
- **LinkedList**：适用于频繁增删、较少查询的场景
- **Vector**：需要线程安全时使用，但通常推荐使用Collections.synchronizedList()

#### 2. Set选择
- **HashSet**：一般场景下的首选，性能最优
- **LinkedHashSet**：需要维护插入顺序时使用
- **TreeSet**：需要排序时使用

#### 3. Map选择
- **HashMap**：一般场景下的首选
- **LinkedHashMap**：需要维护插入顺序时使用
- **TreeMap**：需要排序时使用
- **ConcurrentHashMap**：高并发场景下使用

### 线程安全的集合类

Java还提供了一些线程安全的集合类：

1. **Collections工具类**：
    - Collections.synchronizedList()
    - Collections.synchronizedMap()
    - Collections.synchronizedSet()

2. **java.util.concurrent包**：
    - ConcurrentHashMap
    - CopyOnWriteArrayList
    - BlockingQueue系列

### Java 8新增的集合特性

1. **Stream API**：提供了强大的集合操作功能
2. **Lambda表达式**：简化集合操作的代码
3. **forEach方法**：遍历集合元素
4. **removeIf方法**：按条件删除元素

### 总结

Java集合框架提供了丰富的数据结构实现，开发者应根据具体需求选择合适的集合类：

1. 需要有序、可重复元素时选择List
2. 不需要重复元素时选择Set
3. 需要键值对映射时选择Map
4. 考虑性能和线程安全因素选择具体实现类
5. 在高并发场景下使用线程安全的集合类

理解各种集合类的特点和适用场景对于编写高效、稳定的Java程序至关重要。