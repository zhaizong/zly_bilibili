//
//  LiveTableFooterView.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/12/7.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 直播 TableView尾视图
// @use
// @since 1.0.5
// @author 赵林洋
class LiveTableFooterView: UIView {

  // MARK: - Property
  
  var timer: Timer!
  
  fileprivate var _refreshButton: UIButton
  
  fileprivate var _angle: CGFloat = 0.0
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _refreshButton = UIButton(type: .custom)
    super.init(frame: frame)
    
    _refreshButton.frame = .zero
    _refreshButton.setImage(UIImage(named: "home_refresh_new"), for: .normal)
    _refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    
    addSubview(_refreshButton)
    
    _refreshButton.snp.makeConstraints { (make) in
      make.centerY.equalTo(-22)
      make.trailing.equalTo(0)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension LiveTableFooterView {
  
  @objc fileprivate func _refreshButtonDidClick() {
    
//    if timer != nil {
//      timer.invalidate()
//      timer = nil
//    }
    //    timer = Timer(timeInterval: 0.01, target: self, selector: #selector(RecommendRegionFooterView._refreshTransform), userInfo: nil, repeats: true)
    //    RunLoop.current.add(timer, forMode: .defaultRunLoopMode)
    //
    //    regionFooterViewRefreshDataSourceClosure?()
  }
  
  @objc fileprivate func _refreshTransform() {
    
    _angle += 0.11
    if _angle > 6.28 {
      _angle = 0
    }
    _refreshButton.transform = CGAffineTransform(rotationAngle: _angle)
  }
  
}
