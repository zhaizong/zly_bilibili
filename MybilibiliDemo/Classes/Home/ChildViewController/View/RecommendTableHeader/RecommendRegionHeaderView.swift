//
//  RecommendRegionHeaderView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/13.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 首页推荐 分区 header view
// @use RecommendViewController.swift
// @since 1.0.0
// @author 赵林洋
class RecommendRegionHeaderView: UIView {

  // MARK: - Property
  
  var imageString: String? {
    didSet {
      guard let imageString = imageString, imageString != "" else { return }
      _regionImageView.image = UIImage(named: imageString)
    }
  }
  
  var titleString: String? {
    didSet {
      guard let titleString = titleString, titleString != "" else { return }
      _regionLabel.text = titleString
    }
  }
  
  var detailString: String? {
    didSet {
      guard let detailString = detailString, detailString != "" else { return }
      _currentLabel.text = detailString
    }
  }
  
  fileprivate var _regionImageView: UIImageView
  fileprivate var _regionLabel: UILabel
  
  fileprivate var _currentLabel: UILabel
  
  fileprivate var _arrowImageView: UIImageView
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _regionImageView = UIImageView(frame: .zero)
    _regionLabel = UILabel(frame: .zero)
    
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

extension RecommendRegionHeaderView {
  
  fileprivate func _setupApperance() {
    
    _regionImageView.image = UIImage(named: "home_subregion_live")
    
    _regionLabel.text = ""
    _regionLabel.textColor = UIColor.black
    _regionLabel.font = UIFont.systemFont(ofSize: 14)
    
    _arrowImageView.image = UIImage(named: "common_rightArrowShadow")
    
    _currentLabel.text = "进去看看"
    _currentLabel.textColor = UIColor(hexString: "#AAAAAA")
    _currentLabel.font = UIFont.systemFont(ofSize: 14)
    
    addSubview(_regionImageView)
    addSubview(_regionLabel)
    addSubview(_arrowImageView)
    addSubview(_currentLabel)
  }
  
  fileprivate func _layoutSubviews() {
    
    _regionImageView.snp.makeConstraints { (make) in
      make.centerY.equalTo(20)
      make.size.equalTo(20)
      make.leading.equalTo(8)
    }
    
    _regionLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(20)
      make.leading.equalTo(_regionImageView.snp.trailing).offset(8)
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
