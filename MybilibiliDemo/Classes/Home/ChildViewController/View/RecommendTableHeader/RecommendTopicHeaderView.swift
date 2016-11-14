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
  
  fileprivate var _topView: UIView
  fileprivate var _topLineUp: UIView
  fileprivate var _topLineDown: UIView
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _topicImageView = UIImageView(frame: .zero)
    _topicLabel = UILabel(frame: .zero)
    
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

extension RecommendTopicHeaderView {
  
  fileprivate func _setupApperance() {
    
    _topicImageView.image = UIImage(named: "home_topic")
    
    _topicLabel.text = "话题"
    _topicLabel.textColor = UIColor.black
    _topicLabel.font = UIFont.systemFont(ofSize: 14)
    
    _topView.backgroundColor = UIColor(hexString: "#F6F6F6")
    
    _topLineUp.backgroundColor = BBK_Light_Line_Color
    _topLineDown.backgroundColor = BBK_Light_Line_Color
    
    addSubview(_topicImageView)
    addSubview(_topicLabel)
    addSubview(_topView)
    addSubview(_topLineUp)
    addSubview(_topLineDown)
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
