//
//  AdjustSpeedView.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/11/25.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 调节速度view
// @use VideoPlayerControlView.swift
// @since 1.0.5
// @author 赵林洋
class AdjustSpeedView: UIView {
  
  // MARK: - IBOutlet
  
  var iconImageView: UIImageView!
  
  var timeLabel: UILabel!
  
  var speedLabel: UILabel!

  var progressView: UIProgressView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension AdjustSpeedView {
  
  fileprivate func _setupApperance() {
    
    backgroundColor = UIColor.black
    
    iconImageView = UIImageView(frame: .zero)
    iconImageView.image = UIImage(named: "play_retreat_icon")
    
    timeLabel = UILabel(frame: .zero)
    timeLabel.text = "00:52 / 03:40"
    timeLabel.textColor = UIColor.white
    timeLabel.font = UIFont.boldSystemFont(ofSize: 17)
    
    speedLabel = UILabel(frame: .zero)
    speedLabel.text = "+47秒 - 中速进退"
    speedLabel.textColor = UIColor.white
    speedLabel.font = UIFont.systemFont(ofSize: 16)
    
    progressView = UIProgressView(frame: .zero)
    progressView.progressViewStyle = .default
    progressView.progress = 0
    progressView.progressTintColor = UIColor(hexString: "#DB668B")
    progressView.trackTintColor = UIColor(hexString: "#AAAAAA")
    
    addSubview(iconImageView)
    addSubview(timeLabel)
    addSubview(speedLabel)
    addSubview(progressView)
  }
  
  fileprivate func _layoutSubviews() {
   
    iconImageView.snp.makeConstraints { (make) in
      make.width.equalTo(60)
      make.height.equalTo(37)
      make.top.equalTo(snp.top)
      make.centerX.equalTo(0)
    }
    
    timeLabel.snp.makeConstraints { (make) in
      make.top.equalTo(iconImageView.snp.bottom).offset(8)
      make.centerX.equalTo(iconImageView.snp.centerX)
    }
    
    speedLabel.snp.makeConstraints { (make) in
      make.top.equalTo(timeLabel.snp.bottom).offset(4)
      make.centerX.equalTo(iconImageView.snp.centerX)
    }
    
    progressView.snp.makeConstraints { (make) in
      make.top.equalTo(speedLabel.snp.bottom).offset(4)
      make.leading.equalTo(snp.leading)
      make.trailing.equalTo(snp.trailing)
      make.centerX.equalTo(iconImageView.snp.centerX)
    }
    
  }
  
}
