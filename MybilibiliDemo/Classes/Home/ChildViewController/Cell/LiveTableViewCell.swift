//
//  LiveTableViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/31.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 直播内容tableViewCell
// @since 1.0.0
// @author 赵林洋
class LiveTableViewCell: UITableViewCell {

  // MARK: - Property
  
  var Closure
  
  // MARK: - Lifecycle
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
