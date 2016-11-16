//
//  RecommendHotFooterRefreshView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/13.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 首页推荐 -> 热门 footer view -> _refreshButton
// @use RecommendHotFooterView.swift
// @since 1.0.0
// @author 赵林洋
class RecommendHotFooterRefreshView: UIView {

  // MARK: - Property
  
  fileprivate var _refreshButton: UIButton
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _refreshButton = UIButton(type: .custom)
    super.init(frame: frame)
    
    _refreshButton.frame = .zero
    _refreshButton.setImage(UIImage(named: "home_refresh_new"), for: .normal)
    
    addSubview(_refreshButton)
    
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func _layoutSubviews() {
    
    _refreshButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.trailing.equalTo(0)
      make.size.equalTo(90)
    }
  }

}
