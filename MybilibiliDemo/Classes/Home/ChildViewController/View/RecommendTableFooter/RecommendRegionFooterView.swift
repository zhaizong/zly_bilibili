//
//  RecommendRegionFooterView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/13.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 首页推荐 -> 分区 footer view
// @use RecommendViewController.swift
// @since 1.0.0
// @author 赵林洋
class RecommendRegionFooterView: UIView {

  // MARK: - Property
  
  var regionFooterViewClosureDidClick: (() -> Void)?
  
  fileprivate var _refreshButton: UIButton
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _refreshButton = UIButton(type: .custom)
    super.init(frame: frame)
    
    _refreshButton.frame = .zero
    _refreshButton.setImage(UIImage(named: "home_refresh_new"), for: .normal)
    _refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    _refreshButton.addTarget(self, action: #selector(RecommendRegionFooterView._refreshButtonDidClick), for: .touchUpInside)
    
    addSubview(_refreshButton)
    
    _refreshButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.trailing.equalTo(0)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension RecommendRegionFooterView {
  
  @objc fileprivate func _refreshButtonDidClick() {
    
    
  }
  
}
