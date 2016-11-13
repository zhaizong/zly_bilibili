//
//  RecommendHotHeaderView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/11.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 首页推荐 热门 header view
// @use RecommendViewController.swift
// @since 1.0.0
// @author 赵林洋
class RecommendHotHeaderView: UIView {
  
  // MARK: - Property
  
  fileprivate var _recommendImageView: UIImageView
  fileprivate var _recommendLabel: UILabel
  
  fileprivate var _rankingImageView: UIImageView
  fileprivate var _rankingLabel: UILabel
  
  fileprivate var _arrowImageView: UIImageView
  
  fileprivate var _topView: UIView
  fileprivate var _topLine: UIView
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _recommendImageView = UIImageView(frame: .zero)
    _recommendLabel = UILabel(frame: .zero)
    
    _rankingImageView = UIImageView(frame: .zero)
    _rankingLabel = UILabel(frame: .zero)
    
    _arrowImageView = UIImageView(frame: .zero)
    
    _topView = UIView(frame: .zero)
    _topLine = UIView(frame: .zero)
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension RecommendHotHeaderView {
  
  fileprivate func _setupApperance() {
    
    _recommendImageView.image = UIImage(named: "home_recommend")
    _recommendLabel.text = "热门推荐"
    _recommendLabel.textColor = UIColor.black
    _recommendLabel.font = UIFont.systemFont(ofSize: 14)
    
    _rankingImageView.image = UIImage(named: "home_rank")
    _rankingLabel.text = "排行榜"
    _rankingLabel.textColor = UIColor(hexString: "#FF7F00")
    _rankingLabel.font = UIFont.systemFont(ofSize: 14)
    
    _arrowImageView.image = UIImage(named: "common_rightArrowShadow")
    
    _topView.backgroundColor = UIColor(hexString: "#F6F6F6")
    _topLine.backgroundColor = BBK_Light_Line_Color
    
    addSubview(_recommendImageView)
    addSubview(_recommendLabel)
    addSubview(_rankingImageView)
    addSubview(_rankingLabel)
    addSubview(_arrowImageView)
    addSubview(_topView)
    addSubview(_topLine)
  }
  
  fileprivate func _layoutSubviews() {
    
    _recommendImageView.snp.makeConstraints { (make) in
      make.size.equalTo(20)
      make.centerY.equalTo(4)
      make.leading.equalTo(8)
    }
    
    _recommendLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(4)
      make.leading.equalTo(_recommendImageView.snp.trailing).offset(8)
    }
    
    _arrowImageView.snp.makeConstraints { (make) in
      make.centerY.equalTo(4)
      make.size.equalTo(20)
      make.trailing.equalTo(8)
    }
    
    _rankingLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(4)
      make.trailing.equalTo(_arrowImageView.snp.leading).offset(8)
    }
    
    _rankingImageView.snp.makeConstraints { (make) in
      make.centerY.equalTo(4)
      make.size.equalTo(20)
      make.trailing.equalTo(_rankingLabel.snp.leading).offset(8)
    }
    
    _topView.snp.makeConstraints { (make) in
      make.top.equalTo(0)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.height.equalTo(8)
    }
    
    _topLine.snp.makeConstraints { (make) in
      make.top.equalTo(_topView.snp.bottom)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.height.equalTo(0.5)
    }
    
  }
  
}
















