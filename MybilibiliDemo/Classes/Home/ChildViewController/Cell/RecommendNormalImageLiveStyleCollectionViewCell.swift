//
//  RecommendLargeImageCollectionViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/7.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 普通四图 直播类型 collectionView cell
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
  fileprivate var _onlineCountLabel: UILabel // 观看人数标签
  fileprivate var _titleLabel: UILabel // 标题标签
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
    _onlineCountLabel = UILabel(frame: .zero)
    _titleLabel = UILabel(frame: .zero)
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
    
    _authorNameLabel.text = "up主"
    _authorNameLabel.textColor = UIColor.black
    _authorNameLabel.font = UIFont.systemFont(ofSize: 15)
    
    _onlineCountLabel.text = "2333"
    _onlineCountLabel.textColor = UIColor.black
    _onlineCountLabel.font = UIFont.systemFont(ofSize: 14)
    
    _titleLabel.text = "hahaha"
    _titleLabel.textColor = UIColor.lightGray
    _titleLabel.font = UIFont.systemFont(ofSize: 14)
  }
  
  fileprivate func _layoutSubviews() {
    
    _contentImageView.snp.makeConstraints { (make) in
      make.height.equalTo(120)
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
      make.top.equalTo(_contentImageView.snp.bottom).offset(8)
      make.leading.equalTo(_iconImageView.snp.trailing).offset(4)
      make.trailing.greaterThanOrEqualTo(contentView.snp.trailing).offset(8)
    }
    
    _onlineCountLabel.snp.makeConstraints { (make) in
      make.top.equalTo(_authorNameLabel.snp.bottom).offset(4)
      make.leading.equalTo(_contentImageView.snp.leading)
    }
    
    _titleLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(_onlineCountLabel.snp.centerY)
      make.leading.equalTo(_onlineCountLabel.snp.trailing).offset(4)
      make.trailing.greaterThanOrEqualTo(contentView.snp.trailing)
    }
  }
}

















