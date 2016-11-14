//
//  RecommendLargeImageTableViewCollectionViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/11.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 大图 collectionView cell
// @use RecommendLargeImageTableViewCell.swift
// @since 1.0.0
// @author 赵林洋
class RecommendLargeImageTableViewCollectionViewCell: UICollectionViewCell {
  
  // MARK: Property
  
  var model: [String: Any]? {
    didSet {
      guard let model = model, model.count != 0 else { return }
      if let cover = model["cover"] {
        if let url = URL(string: cover as! String) {
          _imageView.yy_setImage(with: url, placeholder: _placeholderImage, options: [.progressiveBlur, .setImageWithFadeAnimation], completion: nil)
        }
      }
    }
  }
  
  fileprivate var _imageView: UIImageView
  
  fileprivate lazy var _placeholderImage: UIImage = {
    let margin: CGFloat = 8
    let width: CGFloat = BBK_Screen_Width - 2 * margin
    let height: CGFloat = 120
    let lazilyCreatedPlaceholderImage = UIImage.generateCenterImageWithBgColor(BBK_Main_Placeholder_Background_Color, bgImageSize: CGSize(width: width, height: height), centerImage: UIImage(named: "default_img")!)
    return lazilyCreatedPlaceholderImage!
  }()
  
  override init(frame: CGRect) {
    _imageView = UIImageView(frame: .zero)
    super.init(frame: frame)
    
    _imageView.layer.cornerRadius = 5
    _imageView.contentMode = .scaleAspectFill
    _imageView.clipsToBounds = true
    
    contentView.addSubview(_imageView)
    _imageView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top)
      make.bottom.equalTo(contentView.snp.bottom)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
