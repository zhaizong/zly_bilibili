//
//  RecommendLargeImageCollectionViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/7.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 普通四图 直播类型 collectionView cell
// @use RecommendNormalImageTableViewCell.swift
// @since 1.0.0
// @author 赵林洋
class RecommendNormalImageLiveStyleCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Property
  
  var authorNameString: String? {
    didSet {
      guard let authorNameString = authorNameString, authorNameString != "" else { return }
      _authorNameLabel.text = authorNameString
    }
  }
  
  var onlineCountString: String? {
    didSet {
      guard let onlineCountString = onlineCountString, onlineCountString != "" else { return }
      _onlineCountLabel.text = onlineCountString
    }
  }
  
  var titleString: String? {
    didSet {
      guard let titleString = titleString, titleString != "" else { return }
      _titleLabel.text = titleString
    }
  }
  
  var iconImageString: String? {
    didSet {
      guard let iconImageString = iconImageString, iconImageString != "" else { return }
      if let url = URL(string: iconImageString) {
        let placeholderImage = UIImage.circleImageWithOldImage(_iconPlaceholderImage, borderWidth: 3, borderColor: BBK_Main_White_Color)
        _iconImageView.sd_setImage(with: url, placeholderImage: placeholderImage, options: .avoidAutoSetImage) { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
          if let image = image {
            self._iconImageView.image = UIImage.circleImageWithOldImage(image, borderWidth: 3, borderColor: BBK_Main_White_Color)
          } else {
            self._iconImageView.image = UIImage.circleImageWithOldImage(self._iconPlaceholderImage, borderWidth: 3, borderColor: BBK_Main_White_Color)
          }
        }
      }
    }
  }
  
  var contentImageString: String? {
    didSet {
      guard let contentImageString = contentImageString, contentImageString != "" else { return }
      if let url = URL(string: contentImageString) {
        _contentImageView.yy_setImage(with: url, placeholder: _contentPlaceholderImage, options: [.progressiveBlur, .setImageWithFadeAnimation], completion: nil)
      }
    }
  }
  
  fileprivate var _contentImageView: UIImageView // 内容图片
  fileprivate var _iconImageView: UIImageView // 头像图片
  fileprivate var _authorNameLabel: UILabel // up主名字标签
  fileprivate var _onlineEyeImageView: UIImageView // 在线人数图标
  fileprivate var _onlineCountLabel: UILabel // 观看人数标签
  fileprivate var _titleLabel: UILabel // 标题标签
  fileprivate var _shadowImageView: BBKGradientView
  fileprivate lazy var _contentPlaceholderImage: UIImage = {
    let margin = 8
    let width = (BBK_Screen_Width - 3 * CGFloat(margin)) * 0.5
    let height: CGFloat = 120.0
    let lazilyCreatedPlaceholderImage = UIImage.generateCenterImageWithBgColor(BBK_Main_Placeholder_Background_Color, bgImageSize: CGSize(width: width, height: height), centerImage: UIImage(named: "default_img")!)
    return lazilyCreatedPlaceholderImage!
  }()// 内容图片占位图
  fileprivate lazy var _iconPlaceholderImage: UIImage = {
    let lazilyCreatedPlaceholderImage = UIImage.generateCenterImageWithBgColor(BBK_Main_Placeholder_Background_Color, bgImageSize: CGSize(width: 44, height: 44), centerImage: UIImage(named: "default_img")!)
    return lazilyCreatedPlaceholderImage!
  }()// 头像图片占位图
  
  override init(frame: CGRect) {
    _contentImageView = UIImageView(frame: .zero)
    _iconImageView = UIImageView(frame: .zero)
    _authorNameLabel = UILabel(frame: .zero)
    _onlineEyeImageView = UIImageView(frame: .zero)
    _onlineCountLabel = UILabel(frame: .zero)
    _titleLabel = UILabel(frame: .zero)
    _shadowImageView = BBKGradientView(frame: .zero)
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension RecommendNormalImageLiveStyleCollectionViewCell {
  
  fileprivate func _setupApperance() {
  
    _contentImageView.layer.cornerRadius = 5
    _contentImageView.contentMode = .scaleAspectFill
    _contentImageView.clipsToBounds = true
    
    _iconImageView.contentMode = .scaleAspectFill
    _iconImageView.clipsToBounds = true
    _iconImageView.isHidden = true
    
    _authorNameLabel.text = "up主"
    _authorNameLabel.textColor = UIColor.white
    _authorNameLabel.font = UIFont.systemFont(ofSize: 12)
    
    _onlineEyeImageView.image = UIImage(named: "live_eye_ico")
    
    _onlineCountLabel.text = "5000"
    _onlineCountLabel.textColor = UIColor.white
    _onlineCountLabel.font = UIFont.systemFont(ofSize: 12)
    
    _titleLabel.text = ""
    _titleLabel.textColor = UIColor.black
    _titleLabel.font = UIFont.systemFont(ofSize: 14)
    _titleLabel.numberOfLines = 2
    
    _shadowImageView.contentMode = .scaleAspectFill
    _shadowImageView.clipsToBounds = true
    _shadowImageView.alpha = 0.2
    _shadowImageView.setNeedsDisplay()
    
    contentView.addSubview(_contentImageView)
    _contentImageView.addSubview(_shadowImageView)
    _contentImageView.addSubview(_authorNameLabel)
    _contentImageView.addSubview(_onlineEyeImageView)
    _contentImageView.addSubview(_onlineCountLabel)
    contentView.addSubview(_iconImageView)
    contentView.addSubview(_titleLabel)
  }
  
  fileprivate func _layoutSubviews() {
    
    _contentImageView.snp.makeConstraints { (make) in
      make.height.equalTo(100)
      make.top.equalTo(contentView.snp.top)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
    }
    
    _iconImageView.snp.makeConstraints { (make) in
      make.width.equalTo(44)
      make.height.equalTo(44)
      make.leading.equalTo(_contentImageView.snp.leading).offset(4)
      make.bottom.equalTo(_contentImageView.snp.bottom).offset(22)
    }
    
    _authorNameLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(_contentImageView.snp.leading).offset(5)
      make.bottom.equalTo(_contentImageView.snp.bottom).offset(-8)
      make.width.equalTo(70)
    }
    
    _onlineCountLabel.snp.makeConstraints { (make) in
      make.trailing.equalTo(-5)
      make.centerY.equalTo(_authorNameLabel.snp.centerY)
    }
    
    _onlineEyeImageView.snp.makeConstraints { (make) in
      make.trailing.equalTo(_onlineCountLabel.snp.leading).offset(-5)
      make.width.equalTo(15)
      make.height.equalTo(10)
      make.centerY.equalTo(_authorNameLabel.snp.centerY)
    }
    
    _titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(_contentImageView.snp.bottom).offset(4)
      make.leading.equalTo(_contentImageView.snp.leading).offset(1)
      make.trailing.equalTo(contentView.snp.trailing).offset(-4)
    }
    
    _shadowImageView.snp.makeConstraints { (make) in
      make.leading.equalTo(_contentImageView.snp.leading)
      make.bottom.equalTo(_contentImageView.snp.bottom)
      make.trailing.equalTo(_contentImageView.snp.trailing)
      make.height.equalTo(120)
    }
  }
}

















