# WebView TV Player - Flutter Windows 实现

## 项目概述

本项目是使用 Flutter 实现的 Windows 平台 WebView 电视直播播放器，基于 `WebViewTvLive` 项目的设计理念，通过 WebView 加载各大电视台的官方直播页面。

## 技术架构

### 核心依赖

| 依赖包 | 版本 | 说明 |
|--------|------|------|
| `flutter` | SDK >=3.0.0 | Flutter 框架 |
| `in_app_webview` | ^0.8.0+2 | 跨平台 WebView 组件 |
| `flutter_bloc` | ^8.1.3 | 状态管理 |
| `equatable` | ^2.0.5 | 值相等性比较 |

### 目录结构

```
webview_tv_player/
├── lib/
│   ├── main.dart                    # 应用入口
│   ├── bloc/
│   │   ├── tv_player_bloc.dart      # BLoC 业务逻辑
│   │   ├── tv_player_event.dart     # 事件定义
│   │   └── tv_player_state.dart     # 状态定义
│   ├── models/
│   │   └── channel.dart             # 数据模型
│   ├── pages/
│   │   └── tv_player_page.dart      # 主页面
│   └── widgets/
│       ├── webview_player.dart      # WebView 播放器组件
│       ├── channel_list_widget.dart # 频道列表组件
│       └── category_tab_bar.dart    # 分类 TabBar
├── assets/
│   └── channels.json                # 频道配置数据
├── pubspec.yaml                     # 项目配置
└── README.md                        # 项目说明
```

## 功能特性

### 已实现功能

1. **频道分类浏览**
   - 按类别（央视、省级卫视、测试流）组织频道
   - TabBar 快速切换分类

2. **频道列表**
   - 展示所有可用频道
   - 显示当前播放频道
   - 支持滚动浏览

3. **WebView 播放**
   - 使用 `in_app_webview` 加载直播页面
   - 支持 m3u8 (HLS) 流媒体
   - 加载进度显示

4. **频道切换**
   - 点击切换频道
   - 上下键导航切换
   - 左右键导航切换

5. **全屏模式**
   - F11/Enter 进入全屏
   - ESC 退出全屏

6. **键盘控制**
   - 方向键：切换频道
   - F11/Enter：全屏切换
   - ESC：退出全屏
   - Ctrl+R：刷新

### 数据模型

```dart
// 频道模型
class Channel {
  String id;      // 频道唯一标识
  String name;    // 频道名称
  String logo;    // 频道图标
  String url;    // 直播页面URL
}

// 频道分类
class ChannelCategory {
  String name;           // 分类名称
  List<Channel> channels; // 频道列表
}
```

## WebView 协议支持

本播放器通过 WebView 加载直播内容，支持以下协议：

| 协议 | 说明 | 示例 |
|------|------|------|
| **HTTPS/HTTP** | 网页直播 | `https://tv.cctv.com/live/cctv1/` |
| **m3u8** | HLS 流媒体 | `https://example.com/stream.m3u8` |
| **WebView 加载** | 电视台官网直播页面 | 各种官方直播页面 |

## 状态管理

使用 BLoC 模式进行状态管理：

```
TvPlayerBloc
├── LoadChannelsEvent      # 加载频道列表
├── SelectChannelEvent     # 选择频道
├── ChangeCategoryEvent    # 切换分类
├── NavigateChannelEvent   # 频道导航
├── ToggleFullscreenEvent  # 全屏切换
└── ReloadStreamEvent      # 重新加载
```

## 运行要求

### Windows 环境

- Windows 10/11
- WebView2 Runtime (Windows 11 已内置，Windows 10 需安装)
- Flutter SDK >= 3.0.0

### 安装步骤

```bash
# 克隆项目
git clone <repository-url>
cd webview_tv_player

# 安装依赖
flutter pub get

# 运行应用
flutter run -d windows
```

## 与原项目对比

| 特性 | WebViewTvLive (原) | 本项目 |
|------|-------------------|--------|
| 平台 | Android | Windows (Flutter) |
| WebView | 腾讯X5 WebView | in_app_webview |
| 语言 | Kotlin | Dart |
| 状态管理 | 原生 | BLoC |
| 数据格式 | 加密 .dat | JSON |
| 内核选择 | TBS 可选 | WebView2 |

## 已知限制

1. **Windows WebView 支持**: `in_app_webview` 在 Windows 上需要 WebView2 Runtime
2. **m3u8 直接播放**: 部分 m3u8 流可能需要 HLS.js 支持，WebView 内部可能需要额外配置
3. **性能**: WebView 播放对系统性能有一定要求

## 扩展建议

1. **添加更多频道**: 编辑 `assets/channels.json`
2. **自定义 UI**: 修改 `lib/pages/tv_player_page.dart`
3. **添加收藏功能**: 在 BLoC 中添加 favorites 状态
4. **历史记录**: 添加最近观看频道记录
5. **节目预告**: 集成节目单功能

## 参考链接

- [Flutter 官方文档](https://docs.flutter.dev)
- [in_app_webview 包](https://pub.dev/packages/in_app_webview)
- [flutter_bloc 文档](https://bloclibrary.dev)
