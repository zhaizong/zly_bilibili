//
//  RecommendSmallImageTableViewCollectionViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/11.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 电视剧small collectionView cell
// @use RecommendSmallImageTableViewCell.swift
// @since 1.0.0
// @author 赵林洋
class RecommendSmallImageTableViewCollectionViewCell: UICollectionViewCell {
  
  // MARK: Property
  
  var imageString: String? {
    didSet {
      guard let imageString = imageString, imageString != "" else { return }
      if let url = URL(string: imageString) {
        _imageView.yy_setImage(with: url, placeholder: _placeholderImage, options: [.progressiveBlur, .setImageWithFadeAnimation], completion: nil)
      }
    }
  }
  var titleString: String? {
    didSet {
      guard let titleString = titleString, titleString != "" else { return }
      _titleLabel.text = titleString
    }
  }
  var detailInt: Int? {
    didSet {
      guard let detailInt = detailInt else { return }
      _detailLabel.text = "更新到第\(detailInt)话"
    }
  }
  
  fileprivate var _imageView: UIImageView // 封面
  fileprivate var _titleLabel: UILabel // 电视剧名字
  fileprivate var _detailLabel: UILabel // 详情标签 (更新到第xx话)
  
  fileprivate lazy var _placeholderImage: UIImage = {
    let margin: CGFloat = 8
    let width: CGFloat = BBK_Screen_Width - 2 * margin
    let height: CGFloat = 120
    let lazilyCreatedPlaceholderImage = UIImage.generateCenterImageWithBgColor(BBK_Main_Placeholder_Background_Color, bgImageSize: CGSize(width: width, height: height), centerImage: UIImage(named: "default_img")!)
    return lazilyCreatedPlaceholderImage!
  }()
  
  override init(frame: CGRect) {
    _imageView = UIImageView(frame: .zero)
    _titleLabel = UILabel(frame: .zero)
    _detailLabel = UILabel(frame: .zero)
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension RecommendSmallImageTableViewCollectionViewCell {
  
  fileprivate func _setupApperance() {
    
    _imageView.layerCornerRadius = 8
    
    _titleLabel.textColor = UIColor.black
    _titleLabel.font = UIFont.systemFont(ofSize: 14)
    _titleLabel.textAlignment = .center
    _titleLabel.contentMode = .left
    
    _detailLabel.textColor = UIColor.lightGray
    _detailLabel.font = UIFont.systemFont(ofSize: 15)
    _detailLabel.contentMode = .left
    
    contentView.addSubview(_imageView)
    contentView.addSubview(_titleLabel)
    contentView.addSubview(_detailLabel)
  }
  
  fileprivate func _layoutSubviews() {
    
    _imageView.snp.makeConstraints { (make) in
      make.height.equalTo(100)
      make.top.equalTo(contentView.snp.top)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
    }
    
    _titleLabel.snp.makeConstraints { (make) in
      make.centerX.equalTo(contentView.snp.centerX)
      make.top.equalTo(_imageView.snp.bottom).offset(8)
      make.leading.greaterThanOrEqualTo(0)
      make.trailing.greaterThanOrEqualTo(0)
    }
    
    _detailLabel.snp.makeConstraints { (make) in
      make.centerX.equalTo(contentView.snp.centerX)
      make.top.equalTo(_titleLabel.snp.bottom).offset(8)
      make.leading.greaterThanOrEqualTo(0)
      make.trailing.greaterThanOrEqualTo(0)
    }
    
  }
}
