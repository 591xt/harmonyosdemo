# 首选项（ArkTS）

### 简介

基于首选项，实现对本地应用数据的访问及操作。效果图如下：

![image](screenshots/device/preference.gif)

### 相关概念

- [用户首选项](https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/js-apis-data-preferences-0000001427745052-V3?catalogVersion=V3) ：首选项为应用提供Key-Value键值型的数据处理能力，支持应用持久化轻量级数据，并对其修改和查询。数据存储形式为键值对，键的类型为字符串型，值的存储数据类型包括数字型、字符型、布尔型以及这3种类型的数组类型。
- [TextInput](https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/ts-basic-components-textinput-0000001427584864-V3?catalogVersion=V3) ：单行文本输入框组件。

- [Button](https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/ts-basic-components-button-0000001427584848-V3?catalogVersion=V3) ：按钮组件，可快速创建不同样式的按钮。

### 相关权限

不涉及

### 使用说明

1. 在Fruit和Number文本输入框中，输入对应的水果名称和水果数量，点击**Write DB**按钮，将输入的数据保存到首选项中。
2. 退出应用再重新进入，在Fruit和Number文本输入框中对应显示上一次保存的数据。
3. 点击**Read DB**按钮，在Fruit和Number文本输入框中对应显示上一次保存的数据。
4. 点击**Delete DB File**按钮，Fruit和Number文本输入框中的数据清空，并删除首选项中的数据及对应的数据库文件。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机。
2. 本示例为Stage模型，支持API version 9。
3. 本示例需要使用DevEco Studio 3.1 Release版本进行编译运行。