//
//  RecommendAVHeaderView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/13.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 首页推荐 AV header view
// @use RecommendViewController.swift
// @since 1.0.0
// @author 赵林洋
class RecommendAVHeaderView: UIView {

  // MARK: - Property
  
  fileprivate var _topView: UIView
  fileprivate var _topLineUp: UIView
  fileprivate var _topLineDown: UIView
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _topView = UIView(frame: .zero)
    _topLineUp = UIView(frame: .zero)
    _topLineDown = UIView(frame: .zero)
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension RecommendAVHeaderView {
  
  fileprivate func _setupApperance() {
    
    _topView.backgroundColor = UIColor(hexString: "#F6F6F6")
    
    _topLineUp.backgroundColor = BBK_Light_Line_Color
    _topLineDown.backgroundColor = BBK_Light_Line_Color
    
    addSubview(_topView)
    addSubview(_topLineUp)
    addSubview(_topLineDown)
  }
  
  fileprivate func _layoutSubviews() {
    
    _topLineUp.snp.makeConstraints { (make) in
      make.top.equalTo(0)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.height.equalTo(0.5)
    }
    
    _topView.snp.makeConstraints { (make) in
      make.top.equalTo(_topLineUp.snp.bottom)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.height.equalTo(8)
    }
    
    _topLineDown.snp.makeConstraints { (make) in
      make.top.equalTo(_topView.snp.bottom)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.height.equalTo(0.5)
    }
    
  }
  
}
