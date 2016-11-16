//
//  RecommendBangumiFooterView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/13.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 首页推荐 -> 番剧 footer view
// @use RecommendViewController.swift
// @since 1.0.0
// @author 赵林洋
class RecommendBangumiFooterView: UIView {

  // MARK: - Property
  
  fileprivate var _everyDayImageView: UIImageView
  
  fileprivate var _indexImageView: UIImageView
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _everyDayImageView = UIImageView(frame: .zero)
    _indexImageView = UIImageView(frame: .zero)
    super.init(frame: frame)
    
    _everyDayImageView.image = UIImage(named: "home_bangumi_timeline")
    
    _indexImageView.image = UIImage(named: "home_bangumi_category")
    
    addSubview(_everyDayImageView)
    addSubview(_indexImageView)
    
    _everyDayImageView.snp.makeConstraints { (make) in
      make.top.equalTo(20)
      make.leading.equalTo(10)
      make.height.equalTo(54)
    }
    
    _indexImageView.snp.makeConstraints { (make) in
      make.top.equalTo(_everyDayImageView.snp.top)
      make.leading.equalTo(_everyDayImageView.snp.trailing).offset(12)
      make.trailing.equalTo(-10)
      make.size.equalTo(_everyDayImageView.snp.size)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
