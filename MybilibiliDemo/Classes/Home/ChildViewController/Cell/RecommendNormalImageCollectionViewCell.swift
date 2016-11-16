//
//  RecommendNormalImageCollectionViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/7.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 普通四图 普通类型 collectionView cell
// @use RecommendNormalImageTableViewCell.swift
// 普通 - 170高度  直播 - 167高度  番剧 - 166高度
// @since 1.0.0
// @author 赵林洋
class RecommendNormalImageCollectionViewCell: UICollectionViewCell {
 
  // MARK: - Property
  
  var titleString: String? {
    didSet {
      guard let titleString = titleString, titleString != "" else { return }
      _titleLabel.text = titleString
    }
  }
  
  var playCountString: String? {
    didSet {
      guard let playCountString = playCountString, playCountString != "" else { return }
      _playCountLabel.text = playCountString
    }
  }
  
  var danmukuCountString: String? {
    didSet {
      guard let danmukuCountString = danmukuCountString, danmukuCountString != "" else { return }
      _danmukuCountLabel.text = danmukuCountString
    }
  }
  
  var imageViewString: String? {
    didSet {
      guard let imageViewString = imageViewString, imageViewString != "" else { return }
      if let url = URL(string: imageViewString) {
        _imageView.yy_setImage(with: url, placeholder: _placeholderImage, options: [.progressiveBlur, .setImageWithFadeAnimation], completion: nil)
      }
    }
  }
  
  fileprivate var _imageView: UIImageView // 图片imageView
  fileprivate var _titleLabel: UILabel // 标题
  fileprivate var _playCountLabel: UILabel // 播放数
  fileprivate var _danmukuCountLabel: UILabel // 弹幕数
  fileprivate var _playIconImageView: UIImageView
  fileprivate var _danmukuIconImageView: UIImageView
  fileprivate var _shadowImageView: BBKGradientView
  fileprivate lazy var _placeholderImage: UIImage = {
    let margin = 8
    let width = (BBK_Screen_Width - 3 * CGFloat(margin)) * 0.5
    let height: CGFloat = 120.0
    let lazilyCreatedImage = UIImage.generateCenterImageWithBgColor(BBK_Main_Placeholder_Background_Color, bgImageSize: CGSize(width: width, height: height), centerImage: UIImage(named: "default_img")!)
    return lazilyCreatedImage!
  }()// 占位图
  
  override init(frame: CGRect) {
    _imageView = UIImageView(frame: .zero)
    _titleLabel = UILabel(frame: .zero)
    _playCountLabel = UILabel(frame: .zero)
    _danmukuCountLabel = UILabel(frame: .zero)
    _playIconImageView = UIImageView(frame: .zero)
    _danmukuIconImageView = UIImageView(frame: .zero)
    _shadowImageView = BBKGradientView(frame: .zero)
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension RecommendNormalImageCollectionViewCell {
  
  fileprivate func _setupApperance() {
    
    _imageView.layer.cornerRadius = 5
    _imageView.contentMode = .scaleAspectFill
    _imageView.clipsToBounds = true
    
    _titleLabel.text = "haha"
    _titleLabel.textColor = UIColor.black
    _titleLabel.font = UIFont.systemFont(ofSize: 14)
    _titleLabel.numberOfLines = 2
    
    _playCountLabel.text = "110"
    _playCountLabel.textColor = UIColor.white
    _playCountLabel.font = UIFont.systemFont(ofSize: 12)
    
//    _danmukuCountLabel.text = "110"
//    _danmukuCountLabel.textColor = UIColor.white
//    _danmukuCountLabel.font = UIFont.systemFont(ofSize: 12)
    
    _playIconImageView.image = UIImage(named: "mine_favourite_playCount_hd")
    
//    _danmukuIconImageView.image = UIImage(named: "recommed_danmuCount")
    
    _shadowImageView.contentMode = .scaleAspectFill
    _shadowImageView.clipsToBounds = true
    _shadowImageView.alpha = 0.2
    _shadowImageView.setNeedsDisplay()
    
    contentView.addSubview(_imageView)
    _imageView.addSubview(_shadowImageView)
    _imageView.addSubview(_playCountLabel)
//    _imageView.addSubview(_danmukuCountLabel)
    _imageView.addSubview(_playIconImageView)
//    _imageView.addSubview(_danmukuIconImageView)
    contentView.addSubview(_titleLabel)
  }
  
  fileprivate func _layoutSubviews() {
    
    _imageView.snp.makeConstraints { (make) in
      make.height.equalTo(100)
      make.top.equalTo(contentView.snp.top)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
    }
    
    _playIconImageView.snp.makeConstraints { (make) in
      make.leading.equalTo(_imageView.snp.leading).offset(4)
      make.bottom.equalTo(-6)
    }
    
    _playCountLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(_playIconImageView.snp.centerY)
      make.leading.equalTo(_playIconImageView.snp.trailing).offset(4)
    }
    
//    _danmukuIconImageView.snp.makeConstraints { (make) in
//      make.leading.equalTo(_imageView.snp.centerX)
//      make.bottom.equalTo(_playIconImageView.snp.centerY)
//    }
//    
//    _danmukuCountLabel.snp.makeConstraints { (make) in
//      make.centerY.equalTo(_danmukuIconImageView.snp.centerY)
//      make.leading.equalTo(_danmukuIconImageView.snp.trailing).offset(4)
//    }
    
    _titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(_imageView.snp.bottom).offset(4)
      make.leading.equalTo(_imageView.snp.leading).offset(4)
      make.trailing.equalTo(_imageView.snp.trailing).offset(-4)
    }
    
    _shadowImageView.snp.makeConstraints { (make) in
      make.leading.equalTo(_imageView.snp.leading)
      make.bottom.equalTo(_imageView.snp.bottom)
      make.trailing.equalTo(_imageView.snp.trailing)
      make.height.equalTo(120)
    }
  }
}













