# 计步器卡片（JS）

### 简介
本篇Codelab基于Stage模型实现带有卡片的计步应用，用于介绍卡片的开发及生命周期实现。效果如图所示：

![](screenshots/device/StepCard.gif)

### 相关概念

- [消息通知](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/text-notification-0000001478340981-V3?catalogVersion=V3)：提供通知管理的能力，包括发布、取消发布通知，创建、获取、移除通知通道，订阅、取消订阅通知，获取通知的使能状态、角标使能状态，获取通知的相关信息等。
- [关系型数据库](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/data-persistence-by-rdb-store-0000001505752421-V3?catalogVersion=V3)：关系型数据库基于SQLite组件提供了一套完整的对本地数据库进行管理的机制，对外提供了一系列的增、删、改、查等接口，也可以直接运行用户输入的SQL语句来满足复杂的场景需要。
- [元服务卡片开发](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/js-ui-widget-development-0000001535946225-V3?catalogVersion=V3)：卡片是一种界面展示形式，可以将应用的重要信息或操作前置到卡片，以达到服务直达，减少体验层级的目的。
  - 卡片提供方：显示卡片内容，控制卡片布局以及控件点击事件。
  - 卡片使用方：显示卡片内容的宿主应用，控制卡片在宿主中展示的位置。
  - 卡片管理服务：用于管理系统中所添加卡片的常驻代理服务，包括卡片对象的管理与使用，以及卡片周期性刷新等。



### 相关权限

不涉及

### 使用说明

1. 打开应用，显示主页面，每隔10秒，界面步数会发生变化，通知栏显示步数通知。
2. 应用退出到后台，长按应用，点击元服务卡片，选择2x2或2x4元服务卡片，添加到桌面，每隔10秒，更新元服务卡片步数，通知栏看到最新步数通知。
3. 点击2x2或2x4元服务卡片，拉起主页面，看到最新步数。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机或运行在DevEco Studio上的华为手机设备模拟器。
2. 本示例为Stage模型，支持API version 9。
3. 本示例需要使用DevEco Studio 3.1 Release版本进行编译运行。

