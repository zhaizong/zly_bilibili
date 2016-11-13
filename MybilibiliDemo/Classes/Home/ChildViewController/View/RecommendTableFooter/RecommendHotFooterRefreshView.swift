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
  
  fileprivate var _backgroundImageView: UIImageView
  
  fileprivate var _titleLabel: UILabel
  
  fileprivate var _refreshIconImageView: UIImageView
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _backgroundImageView = UIImageView(frame: .zero)
    _titleLabel = UILabel(frame: .zero)
    _refreshIconImageView = UIImageView(frame: .zero)
    super.init(frame: frame)
    
    _backgroundImageView.image = UIImage(named: "bg_text_field_mono_light")
    _backgroundImageView.layer.cornerRadius = 18
    _backgroundImageView.layer.masksToBounds = true
    
    _titleLabel.text = "换一波推荐"
    _titleLabel.textColor = UIColor.black
    
    _refreshIconImageView.image = UIImage(named: "home_refresh")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func _layoutSubviews() {
    
    _backgroundImageView.snp.makeConstraints { (make) in
      make.top.equalTo(0)
      make.bottom.equalTo(0)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
    }
    
    _titleLabel.snp.makeConstraints { (make) in
      make.center.equalTo(0)
    }
    
    _refreshIconImageView.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.trailing.equalTo(-8)
      make.size.equalTo(20)
    }
  }

}
