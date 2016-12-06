//
//  BBKCommons.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/10/20.
//  Copyright © 2016年 Zly. All rights reserved.
//

import Foundation
import UIKit

// Enum

@objc public enum LiveEntranceIconsViewAreaType: Int {
  case single = 1 // 单机联机 id = 1
  case otaku = 2 // 御宅文化 id = 2
  case gameOnline = 3 // 网络游戏 id = 3
  case eSports = 4 // 电子竞技 id = 4
  case video = 7 // 放映厅 id = 7
  case meng = 8 // 萌宅推荐 id = 8
  case painting = 9 // 绘画专区 id = 9
  case dance = 10 // 唱见舞见 id = 10
  case phone = 11 // 手机直播 id = 11
  case phoneGame = 12 // 手游直播 id = 12
  case allCategory = 10086 // 全部分类 id = 10086
  case allLive // 全部直播 id = 10087
  case attentionAuthor // 关注主播 id = 10088
  case liveCenter // 直播中心 id = 10089
  case searchLive // 搜索直播 id = 10090
}

// Connect

internal let ServerApp = "https://app.bilibili.com"
// 推荐轮播图
public let BBK_Banner_URL = ServerApp + "/x/banner"
// 推荐内容
public let BBK_RecommendContent_URL = ServerApp + "/x/show"

// APP

//  标题被点击或者内容滚动完成，会发出这个通知，监听这个通知，可以做自己想要做的事情，比如加载数据
public let BBK_DisplayView_ClickOrScrollDidFinshNote = "bbk_displayview_clickorscroll_did_finshnote"
// tabBar被选中的通知
public let BBK_TabBar_DidSelectNotification = "bbk_tabBar_didSelectNotification"
// 轮播图将要开始拖动发出的通知
public let BBK_BannerView_WillBeginDraggingNotification = "kBannerViewWillBeginDraggingNotification"
// 轮播图结束滑动发出的通知
public let BBK_BannerView_DidEndDeceleratingNotification = "kBannerViewDidEndDeceleratingNotification"

public let BBK_Screen_Width = UIScreen.main.bounds.size.width
public let BBK_Screen_Height = UIScreen.main.bounds.size.height

// 系统tabbar高度
public let BBK_APP_TabBar_Height: CGFloat = 49
// 系统间距字段 8
public let BBK_App_Padding_8: CGFloat = 8

// Color

// 主题颜色
public let BBK_Main_Color = UIColor(red: 0.89, green: 0.49, blue: 0.61, alpha: 1.0)

public let BBK_Main_Background_Color = UIColor(hexString: "#F6F6F6")

// 主题线的颜色
public let BBK_Main_Line_Color = UIColor(hexString: "#C8C8C8")

public let BBK_Main_White_Color = UIColor.white

// placeholder背景色
public let BBK_Main_Placeholder_Background_Color = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)

// 较浅的线颜色
public let BBK_Light_Line_Color = UIColor(hexString: "#DCDCDC")

