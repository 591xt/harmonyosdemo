# 音乐播放元服务和卡片（ArkTS）

### 简介
基于自适应布局和响应式布局，实现一次开发，多端部署音乐播放元服务，结合ArkTS卡片实现展示当前音乐播放信息以及控制播放能力。

效果图如下：

![](screenshots/device/musicPlay.gif)

### 相关概念
- [AVPlayer](https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/js-apis-media-0000001427902672-V3?ha_linker=eyJ0cyI6MTY5NDY3MTcxMzA0NSwiaWQiOiJmMDZiYWZkNWQ2NjAyMDUwZmY4NWVjYmE0ODYxNWU3ZCJ9#ZH-CN_TOPIC_0000001523488666__avplayer9)：AVPlayer主要工作是将Audio/Video媒体资源转码为可供渲染的图像和可听见的音频模拟信号，并通过输出设备进行播放，同时对播放任务进行管理，包括开始播放、暂停播放、停止播放、释放资源、设置音量、跳转播放位置、获取轨道信息等功能控制。
- [后台任务管理](https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/js-apis-resourceschedule-backgroundtaskmanager-0000001544584033-V3?catalogVersion=V3&ha_linker=eyJ0cyI6MTY5NDY3MTcyNjUwNCwiaWQiOiJmMDZiYWZkNWQ2NjAyMDUwZmY4NWVjYmE0ODYxNWU3ZCJ9)：应用中存在用户能够直观感受到的且需要一直在后台运行的业务时（如后台播放音乐），可以使用长时任务机制。

### 相关权限

本篇Codelab需要添加以下权限：

- ohos.permission.KEEP_BACKGROUND_RUNNING

### 使用说明
1. 本篇Codelab为元服务工程，安装到手机后不会在桌面生成桌面图标，通过添加桌面卡片，点击卡片即可进入本应用。
2. 在桌面双指捏合进入桌面编辑页面，点击服务卡片，下滑至底部点击其他服务卡片，点击MusicPlay，即可添加卡片。
3. 点击界面上播放/暂停、上一首、下一首图标控制音乐播放功能。
4. 点击界面上播放控制区空白处或列表歌曲跳转到播放页面。
5. 点击界面上评论按钮跳转到对应的评论页面。
6. 其他按钮无实际点击事件或功能。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：华为手机或运行在DevEco Studio上的华为手机设备模拟器。
2. HarmonyOS系统：4.0.0 Developer Release。
3. 本示例为Stage模型，支持API version 9。
4. 本示例需要使用DevEco Studio 3.1 Release版本进行编译运行。