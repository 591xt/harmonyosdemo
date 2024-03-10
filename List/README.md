# List组件的使用之商品列表（ArkTS）

### 简介
基于ArkTS，使用List组件，实现了商品列表的懒加载、下拉刷新与列表触底提示并回弹的效果。

![](screenshots/List_usage.gif)

### 相关概念
- [Scroll](https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/ts-container-scroll-0000001427902480-V3?catalogVersion=V3)：可滚动的容器组件，当子组件的布局尺寸超过父组件的视口时，内容可以滚动。
- [List](https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/ts-container-list-0000001477981213-V3?catalogVersion=V3)：列表包含一系列相同宽度的列表项。适合连续、多行呈现同类数据，例如图片和文本。
- [Tabs](https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/ts-container-tabs-0000001478181433-V3?catalogVersion=V3)：一种可以通过页签进行内容视图切换的容器组件，每个页签对应一个内容视图。
- [LazyForEach](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-rendering-control-lazyforeach-0000001524417213-V3?catalogVersion=V3)：开发框架提供数据懒加载（LazyForEach组件）从提供的数据源中按需迭代数据，并在每次迭代过程中创建相应的组件。


### 相关权限
不涉及

### 使用说明
1.  点击精选页，下拉拖动会有刷新效果。
2.  向上拉菜单页，到底会提示”已经到底了“字样，并且会跟随商品列表滑动一段距离，松手后会回弹至原来位置。

### 约束与限制
1. 本示例仅支持标准系统上运行，支持设备：华为手机或运行在DevEco Studio上的华为手机设备模拟器。
2. 本示例为Stage模型，支持API version 9。
3. 本示例需要使用DevEco Studio 3.1 Release版本进行编译运行。
