//
//  RecommendLiveHeaderView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/13.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 首页推荐 直播 header view
// @use RecommendViewController.swift
// @since 1.0.0
// @author 赵林洋
class RecommendLiveHeaderView: UIView {

  // MARK: - Property
  
  fileprivate var _liveImageView: UIImageView
  fileprivate var _liveLabel: UILabel
  
  fileprivate var _currentLabel: UILabel
  
  fileprivate var _arrowImageView: UIImageView
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _liveImageView = UIImageView(frame: .zero)
    _liveLabel = UILabel(frame: .zero)
    
    _currentLabel = UILabel(frame: .zero)
    
    _arrowImageView = UIImageView(frame: .zero)
    
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension RecommendLiveHeaderView {
  
  fileprivate func _setupApperance() {
    
    _liveImageView.image = UIImage(named: "home_subregion_live")
    
    _liveLabel.text = "正在直播"
    _liveLabel.textColor = UIColor.black
    _liveLabel.font = UIFont.systemFont(ofSize: 14)
    
    _arrowImageView.image = UIImage(named: "common_rightArrowShadow")
    
    _currentLabel.text = "当前1024个直播，进去看看"
    _currentLabel.textColor = UIColor(hexString: "#AAAAAA")
    _currentLabel.font = UIFont.systemFont(ofSize: 14)
    
    addSubview(_liveImageView)
    addSubview(_liveLabel)
    addSubview(_arrowImageView)
    addSubview(_currentLabel)
  }
  
  fileprivate func _layoutSubviews() {
    
    _liveImageView.snp.makeConstraints { (make) in
      make.centerY.equalTo(20)
      make.size.equalTo(20)
      make.leading.equalTo(8)
    }
    
    _liveLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(20)
      make.leading.equalTo(_liveImageView.snp.trailing).offset(8)
    }
    
    _arrowImageView.snp.makeConstraints { (make) in
      make.centerY.equalTo(20)
      make.trailing.equalTo(-8)
      make.size.equalTo(20)
    }
    
    _currentLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(20)
      make.trailing.equalTo(_arrowImageView.snp.leading).offset(-8)
    }
    
  }
  
}
