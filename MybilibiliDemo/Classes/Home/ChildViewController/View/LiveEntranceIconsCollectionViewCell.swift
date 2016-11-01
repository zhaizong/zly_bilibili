//
//  LiveEntranceIconsCollectionViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/29.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 入口图标Cell
// @since 1.0.0
// @author 赵林洋
class LiveEntranceIconsCollectionViewCell: UICollectionViewCell {
  
  var button: UIButton
  
  var iconUrl: String? {
    didSet {
      guard let iconUrl = iconUrl, iconUrl != "" else { return }
      _iconUrl = iconUrl
    }
  }
  var buttonName: String? {
    didSet {
      guard let buttonName = buttonName, buttonName != "" else { return }
      _buttonName = buttonName
    }
  }
  
  fileprivate var _iconUrl: String {
    didSet {
      guard let url = URL(string: _iconUrl) else { return }
      if let scheme = url.scheme?.lowercased() {
        if scheme == "http" || scheme == "https" {
          button.yy_setImage(with: URL(string: _iconUrl), for: .normal, placeholder: nil, options: .init(rawValue: 0)) {(image: UIImage?, url: URL?, from: YYWebImageFromType, stage: YYWebImageStage, error: Error?) in
            guard let image = image else { return }
            let targetImage = image.yy_imageByResize(to: CGSize(width: 40, height: 40), contentMode: .scaleAspectFit)
            self.button.setImage(targetImage?.yy_image(byRoundCornerRadius: (targetImage?.size.width)! * 0.5), for: .normal)
          }
        } else {
          button.setImage(UIImage(named: _iconUrl), for: .normal)
        }
      }
    }
  }
  fileprivate var _buttonName: String {
    didSet {
      button.setTitle(_buttonName, for: .normal)
    }
  }
  
  override init(frame: CGRect) {
    button = UIButton(type: .custom)
    _iconUrl = ""
    _buttonName = ""
    super.init(frame: frame)
    autoresizingMask = .init(rawValue: 0)
    button.setTitle("[]~(￣▽￣)~*", for: .normal)
    button.setTitleColor(UIColor.blue, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    contentView.addSubview(button)
    button.snp.makeConstraints { (make) in
      make.top.equalTo(0)
      make.bottom.equalTo(0)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    button.imageView?.st_centerX = st_width * 0.5
    button.imageView?.st_centerY = st_width * 0.5 - (button.imageView?.st_width)! * 0.5 + 12
    button.titleLabel?.st_centerX = (button.imageView?.st_centerX)!
    button.titleLabel?.st_top = (button.imageView?.st_bottom)! + 4
  }
  
}

