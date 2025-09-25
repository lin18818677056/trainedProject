
**MySQL 索引的最左前缀匹配原则是什么？**

# Java热门面试题200道

## 6. MySQL 索引的最左前缀匹配原则是什么？


## 面试答案

最左前缀匹配原则（Leftmost Prefix Matching Principle）是MySQL复合索引（联合索引）使用中的一个重要概念，指的是在使用复合索引进行查询时，MySQL会从索引的最左边的列开始匹配，直到遇到范围查询（如<、>、between、like）就停止匹配。

### 核心要点

1. **定义**：当创建复合索引时，MySQL会按照创建索引时列的顺序从左到右构建索引树。查询时只有遵循最左前缀原则，才能有效利用索引。

2. **匹配规则**：
   - 查询条件必须包含索引最左边的列才能使用索引
   - 可以只使用索引左侧的部分列（如索引(a,b,c)，查询条件只包含a或a,b也能使用索引）
   - 遇到范围查询后，右侧的列无法使用索引

3. **示例**：
   假设有复合索引 idx(a,b,c)：
   - `WHERE a=1`：可以使用索引
   - `WHERE a=1 AND b=2`：可以使用索引
   - `WHERE a=1 AND b=2 AND c=3`：可以使用索引
   - `WHERE b=2`：无法使用索引
   - `WHERE a=1 AND c=3`：部分使用索引（只使用a列）
   - `WHERE a>1 AND b=2`：只能使用a列索引，b列无法使用



我来详细解释一下为什么`WHERE b=2`无法使用索引，而`WHERE a=1 AND b=2`可以使用索引。

这涉及到复合索引的结构和最左前缀匹配原则。让我通过一个更详细的解释来帮助你理解：

### 复合索引的内部结构

当我们创建一个复合索引`(a, b, c)`时，MySQL会按照这个顺序来构建B+树索引。索引的排序首先是按照[a](file://C:\Users\Falak\Desktop\Personal\trainedProject\src\main\java\com\trained\project\trainedproject\TrainedProjectApplication.java)列排序，当[a](file://C:\Users\Falak\Desktop\Personal\trainedProject\src\main\java\com\trained\project\trainedproject\TrainedProjectApplication.java)列相同时，再按照`b`列排序，当`b`列也相同时，再按照`c`列排序。

这就像是电话簿的排序方式：
- 首先按照姓氏排序（相当于[a](file://C:\Users\Falak\Desktop\Personal\trainedProject\src\main\java\com\trained\project\trainedproject\TrainedProjectApplication.java)列）
- 姓氏相同时按照名字排序（相当于`b`列）
- 名字也相同时按照中间名排序（相当于`c`列）

### 为什么单独查询b列无法使用索引？

想象一下，如果你想在电话簿中查找所有叫"华"的人（相当于`b`列），但不指定姓氏（[a](file://C:\Users\Falak\Desktop\Personal\trainedProject\src\main\java\com\trained\project\trainedproject\TrainedProjectApplication.java)列）。由于电话簿是先按姓氏排序的，所有叫"华"的人会分散在整个电话簿的各个位置，你无法通过二分查找等高效算法快速定位，只能一页一页地遍历整个电话簿。

这就是为什么`WHERE b=2`无法使用索引的原因 - 因为索引是按照`(a,b,c)`的顺序构建的，没有[a](file://C:\Users\Falak\Desktop\Personal\trainedProject\src\main\java\com\trained\project\trainedproject\TrainedProjectApplication.java)列的条件，数据库无法直接定位到`b`列值为2的记录。

### 为什么加上a列条件就可以使用索引？

当我们使用`WHERE a=1 AND b=2`时，情况就不同了：
1. 首先，MySQL可以快速在索引中找到`a=1`的所有记录（因为索引按[a](file://C:\Users\Falak\Desktop\Personal\trainedProject\src\main\java\com\trained\project\trainedproject\TrainedProjectApplication.java)排序，这部分是连续的）
2. 在`a=1`的范围内，记录是按照`b`列排序的
3. 因此，MySQL可以在`a=1`的范围内使用二分查找等高效算法找到`b=2`的记录

### 关于范围查询的影响

对于`WHERE a>1 AND b=2`，这里使用了范围查询符`>`：
1. MySQL可以使用索引找到`a>1`的记录范围
2. 但是在这个范围内，虽然记录是按照`(b,c)`排序的，但由于[a](file://C:\Users\Falak\Desktop\Personal\trainedProject\src\main\java\com\trained\project\trainedproject\TrainedProjectApplication.java)的值不同（比如有a=2,a=3,a=5等），所以无法直接在整个范围内使用`b=2`的条件进行快速查找
3. 因此，只有[a](file://C:\Users\Falak\Desktop\Personal\trainedProject\src\main\java\com\trained\project\trainedproject\TrainedProjectApplication.java)列能有效利用索引，而`b`列的条件只能在找到记录后再进行过滤

### 实际示例

假设我们有如下数据和索引：
```
(a, b, c)
(1, 1, 1)
(1, 2, 1)
(1, 2, 2)
(2, 1, 1)
(2, 2, 1)
(3, 1, 1)
(3, 2, 1)
```


索引按照`(a,b,c)`排序后：
```
(1, 1, 1)
(1, 2, 1)
(1, 2, 2)
(2, 1, 1)
(2, 2, 1)
(3, 1, 1)
(3, 2, 1)
```


- 查询`WHERE b=2`：需要检查每一行，因为`b=2`的记录分散在整个索引中
- 查询`WHERE a=1 AND b=2`：只需要检查前3行（`a=1`的范围），然后在该范围内快速定位`b=2`的记录

这就是最左前缀匹配原则的核心：索引的使用必须从最左边的列开始，不能跳过前面的列直接使用后面的列。


4. **注意事项**：
   - 等值查询（=）可以跳过中间列，但会影响性能
   - 范围查询（>、<、between、like）会导致后续列无法使用索引
   - ORDER BY子句也遵循最左前缀原则

### 实际应用建议

- 设计复合索引时，应将选择性高的列放在左侧
- 查询时尽量按照索引列的顺序编写WHERE条件
- 避免在索引列上使用函数或表达式，这会导致索引失效

遵循最左前缀匹配原则可以显著提高查询性能，是数据库优化中的重要知识点。