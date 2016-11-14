//
//  RecommendHotFooterView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/13.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 首页推荐 -> 热门 footer view
// @use RecommendViewController.swift
// @since 1.0.0
// @author 赵林洋
class RecommendHotFooterView: UIView {

  // MARK: - Property
  
  fileprivate var _refreshButton: RecommendHotFooterRefreshView
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _refreshButton = RecommendHotFooterRefreshView(frame: .zero)
    super.init(frame: frame)
    
    isUserInteractionEnabled = true
    
    _refreshButton.backgroundColor = UIColor.white
    
    addSubview(_refreshButton)
    _refreshButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(20)
      make.height.equalTo(36)
      make.leading.equalTo(64)
      make.trailing.equalTo(-64)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
