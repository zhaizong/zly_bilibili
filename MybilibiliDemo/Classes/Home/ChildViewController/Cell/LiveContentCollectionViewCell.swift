//
//  LiveContentCollectionViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/1.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 直播内容视图tableViewCell中collectionView的cell
//
// @since 1.0.0
// @author 赵林洋
class LiveContentCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Property
  
  var avatarUrlString: String? { // 头像链接
    didSet {
      guard let avatarUrlString = avatarUrlString, avatarUrlString != "" else { return }
      _avatarImageView.sd_setImage(with: URL(string: avatarUrlString),
                       placeholderImage: _iconImageViewPlaceholderImage)
    }
  }
  var coverUrlString: String? { // 封面图片链接
    didSet {
      guard let coverUrlString = coverUrlString, coverUrlString != "" else { return }
      let width = (BBK_Screen_Width - 3 * BBK_App_Padding_8) * 0.5
      let height = width * 180 / 320
      _coverImageView.yy_setImage(with: URL(string: coverUrlString), placeholder: _contentImageViewPlaceholderImage, options: [.progressiveBlur, .setImageWithFadeAnimation]) { [weak self] (image: UIImage?, url: URL?, type: YYWebImageFromType, stage: YYWebImageStage, error: Error?) in
        guard let weakSelf = self else { return }
        let targetImage = image?.yy_imageByResize(to: CGSize(width: width, height: height), contentMode: .scaleAspectFill)
        weakSelf._coverImageView.image = targetImage?.yy_image(byRoundCornerRadius: 4)
      }
      _coverImageView.snp.updateConstraints { (make) in
        make.height.equalTo(height)
      }
      layoutIfNeeded()
    }
  }
  var nameString: String? { // 名字
    didSet {
      guard let nameString = nameString, nameString != "" else { return }
      _nameLabel.text = nameString
    }
  }
  var viewerString: String? { // 观众数
    didSet {
      guard let viewerString = viewerString, viewerString != "" else { return }
      _viewerCountLabel.text = viewerString
    }
  }
  var titleString: String? { // 标题
    didSet {
      guard let titleString = titleString, titleString != "" else { return }
      _titleLabel.text = titleString
    }
  }
  
  fileprivate lazy var _contentImageViewPlaceholderImage: UIImage = {
    let width = (BBK_Screen_Width - 3 * BBK_App_Padding_8) * 0.5
    let height = width * 180 / 320
    let lazilyCreatedImage = UIImage.generateCenterImageWithBgColor(BBK_Main_Placeholder_Background_Color, bgImageSize: CGSize(width: width, height: height), centerImage: UIImage(named: "default_img")!)
    return lazilyCreatedImage!
  }()
  
  fileprivate lazy var _iconImageViewPlaceholderImage: UIImage = {
    let lazilyCreatedImage = UIImage.generateCenterImageWithBgColor(BBK_Main_Placeholder_Background_Color, bgImageSize: CGSize(width: 44, height: 44), centerImage: UIImage(named: "default_img")!)
    return lazilyCreatedImage!
  }()
  
  fileprivate var _coverImageView: UIImageView // 封面imageView
  fileprivate var _avatarImageView: UIImageView // 头像imageView
  fileprivate var _nameLabel: UILabel // up主名字标签
  fileprivate var _viewerEyeImageView: UIImageView // 在线人数图标
  fileprivate var _viewerCountLabel: UILabel // 观众在线人数标签
  fileprivate var _titleLabel: UILabel // 标题标签
  
  override init(frame: CGRect) {
    _coverImageView = UIImageView(frame: .zero)
    _avatarImageView = UIImageView(frame: .zero)
    _nameLabel = UILabel(frame: .zero)
    _viewerEyeImageView = UIImageView(frame: .zero)
    _viewerCountLabel = UILabel(frame: .zero)
    _titleLabel = UILabel(frame: .zero)
    super.init(frame: frame)
    
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension LiveContentCollectionViewCell {
  
  fileprivate func _layoutSubviews() {
    
    _coverImageView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
      make.height.equalTo(120)
    }
    
    _avatarImageView.snp.makeConstraints { (make) in
      make.size.equalTo(44)
      make.leading.equalTo(_coverImageView.snp.leading).offset(4)
      make.bottom.equalTo(_coverImageView.snp.bottom).offset(22)
    }
    
    _nameLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(_coverImageView.snp.leading).offset(1)
      make.bottom.equalTo(_coverImageView.snp.bottom).offset(-3)
    }
    
    _viewerEyeImageView.snp.makeConstraints { (make) in
      make.leading.equalTo(_nameLabel.snp.trailing).offset(1)
      make.size.equalTo(10)
      make.centerY.equalTo(_nameLabel.snp.centerY)
    }
    
    _viewerCountLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(_viewerEyeImageView.snp.trailing).offset(1)
      make.trailing.equalTo(-1)
      make.centerY.equalTo(_nameLabel.snp.centerY)
    }
    
    _titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(_coverImageView.snp.bottom).offset(4)
      make.leading.equalTo(_coverImageView.snp.leading).offset(1)
      make.trailing.equalTo(contentView.snp.trailing).offset(-4)
    }
  }
  
  fileprivate func _setupApperance() {
    
    autoresizingMask = .init(rawValue: 0)
    backgroundColor = BBK_Main_Background_Color
    
    _avatarImageView.layerCornerRadius = _avatarImageView.st_width * 0.5
    _avatarImageView.layerBorderColor = BBK_Main_White_Color
    _avatarImageView.layerBorderWidth = 1
    
    _viewerCountLabel.layerCornerRadius = 4
    _viewerCountLabel.layerBorderWidth = 1
    _viewerCountLabel.layerBorderColor = BBK_Light_Line_Color
    
    _nameLabel.text = "up主123123123123123"
    _nameLabel.textColor = UIColor.white
    _nameLabel.font = UIFont.systemFont(ofSize: 12)
    
    _titleLabel.text = "哈哈哈"
    _titleLabel.textColor = UIColor.black
    _titleLabel.font = UIFont.systemFont(ofSize: 14)
    _titleLabel.numberOfLines = 2
    
    _viewerEyeImageView.image = UIImage(named: "live_eye_ico")
    
    _viewerCountLabel.text = "2333123123123"
    _viewerCountLabel.textColor = UIColor.white
    _viewerCountLabel.font = UIFont.systemFont(ofSize: 10)
    _viewerCountLabel.textAlignment = .center
    _viewerCountLabel.backgroundColor = UIColor(hexString: "#C8C8C8")
    
    contentView.addSubview(_coverImageView)
    _coverImageView.addSubview(_nameLabel)
    _coverImageView.addSubview(_viewerEyeImageView)
    _coverImageView.addSubview(_viewerCountLabel)
    contentView.addSubview(_avatarImageView)
    contentView.addSubview(_titleLabel)
  }
  
  
}
