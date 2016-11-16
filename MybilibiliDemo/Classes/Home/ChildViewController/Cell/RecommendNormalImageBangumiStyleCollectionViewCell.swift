//
//  RecommendNormalImageBangumiStyleCollectionViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/7.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 普通四图 番剧类型 collectionView Cell
// @use RecommendNormalImageTableViewCell.swift
// @since 1.0.0
// @author 赵林洋
class RecommendNormalImageBangumiStyleCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Property
  
  var imageViewString: String? {
    didSet {
      guard let imageViewString = imageViewString, imageViewString != "" else { return }
      if let url = URL(string: imageViewString) {
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
  
  fileprivate var _imageView: UIImageView // 图像
  fileprivate var _titleLabel: UILabel // 标题标签
  fileprivate var _detailLabel: UILabel // 详情标签 更新时间 · 第xx话
  fileprivate var _shadowImageView: BBKGradientView
  fileprivate lazy var _placeholderImage: UIImage = {
    let margin = 8
    let width = (BBK_Screen_Width - 3 * CGFloat(margin)) * 0.5
    let height: CGFloat = 120.0
    let lazilyCreatedPlaceholderImage = UIImage.generateCenterImageWithBgColor(BBK_Main_Placeholder_Background_Color, bgImageSize: CGSize(width: width, height: height), centerImage: UIImage(named: "default_img")!)
    return lazilyCreatedPlaceholderImage!
  }()// 占位图
  
  override init(frame: CGRect) {
    _imageView = UIImageView(frame: .zero)
    _titleLabel = UILabel(frame: .zero)
    _detailLabel = UILabel(frame: .zero)
    _shadowImageView = BBKGradientView(frame: .zero)
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension RecommendNormalImageBangumiStyleCollectionViewCell {
  
  fileprivate func _setupApperance() {
    
    _imageView.layer.cornerRadius = 5
    _imageView.contentMode = .scaleAspectFill
    _imageView.clipsToBounds = true
    
    _titleLabel.textColor = UIColor.black
    _titleLabel.font = UIFont.systemFont(ofSize: 14)
    
    _detailLabel.text = "业务逻辑 []~(￣▽￣)~*"
    _detailLabel.textColor = UIColor.lightGray
    _detailLabel.font = UIFont.systemFont(ofSize: 14)
    
    _shadowImageView.contentMode = .scaleAspectFill
    _shadowImageView.clipsToBounds = true
    _shadowImageView.alpha = 0.2
    _shadowImageView.setNeedsDisplay()
    
    contentView.addSubview(_imageView)
    _imageView.addSubview(_shadowImageView)
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
      make.top.equalTo(_imageView.snp.bottom).offset(4)
      make.trailing.equalTo(_imageView.snp.trailing).offset(-4)
      make.leading.equalTo(_imageView.snp.leading).offset(4)
    }
    
    _detailLabel.snp.makeConstraints { (make) in
      make.top.equalTo(_titleLabel.snp.bottom).offset(6)
      make.leading.equalTo(_titleLabel.snp.leading)
      make.trailing.equalTo(_titleLabel.snp.trailing)
    }
    
    _shadowImageView.snp.makeConstraints { (make) in
      make.leading.equalTo(_imageView.snp.leading)
      make.bottom.equalTo(_imageView.snp.bottom)
      make.trailing.equalTo(_imageView.snp.trailing)
      make.height.equalTo(120)
    }
  }
}
















