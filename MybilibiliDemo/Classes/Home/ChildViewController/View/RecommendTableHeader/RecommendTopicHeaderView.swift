//
//  RecommendTopicHeaderView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/13.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 首页推荐 话题 header view
// @use RecommendViewController.swift
// @since 1.0.0
// @author 赵林洋
class RecommendTopicHeaderView: UIView {
  
  // MARK: - Property
  
  fileprivate var _topicImageView: UIImageView
  fileprivate var _topicLabel: UILabel
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _topicImageView = UIImageView(frame: .zero)
    _topicLabel = UILabel(frame: .zero)
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension RecommendTopicHeaderView {
  
  fileprivate func _setupApperance() {
    
    _topicImageView.image = UIImage(named: "home_topic")
    
    _topicLabel.text = "话题"
    _topicLabel.textColor = UIColor.black
    _topicLabel.font = UIFont.systemFont(ofSize: 14)
    
    addSubview(_topicImageView)
    addSubview(_topicLabel)
  }
  
  fileprivate func _layoutSubviews() {
    
    _topicImageView.snp.makeConstraints { (make) in
      make.centerY.equalTo(20)
      make.size.equalTo(20)
      make.leading.equalTo(8)
    }
    
    _topicLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(20)
      make.leading.equalTo(_topicImageView.snp.trailing).offset(8)
    }
    
  }
  
}
