//
//  LiveTableHeaderView.swift
//  MybilibiliDemo
//
//  Created by Crazy on 16/12/7.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 直播 TableView头视图
// @use
// @since 1.0.5
// @author 赵林洋
class LiveTableHeaderView: UIView {

  // MARK: - Property
  
  var partition: BBCLivePartition? {
    didSet {
      guard let partition = partition else { return }
      if let url = URL(string: partition.src) {
        _iconImageView.yy_setImage(with: url, placeholder: nil)
      }
      _titleLabel.text = partition.name
      if partition.partitionId == 8 {
        let mutableString = NSMutableAttributedString(string: "进去看看")
        _detailLabel.attributedText = mutableString
      } else {
        let string = "当前\(partition.count)个直播，进去看看"
        let mutableString = NSMutableAttributedString(string: string)
        let attrs = [NSForegroundColorAttributeName: BBK_Main_Color]
        let range = NSMakeRange(2, NSString(string: "\(partition.count)").length)
        mutableString.setAttributes(attrs, range: range)
        _detailLabel.attributedText = mutableString
      }
    }
  }
  
  var headerViewTouchesClosure: (() -> Void)?
  
  fileprivate var _iconImageView: UIImageView
  
  fileprivate var _arrowImageView: UIImageView
  
  fileprivate var _titleLabel: UILabel
  
  fileprivate var _detailLabel: UILabel
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    _iconImageView = UIImageView(frame: .zero)
    _arrowImageView = UIImageView(frame: .zero)
    _titleLabel = UILabel(frame: .zero)
    _detailLabel = UILabel(frame: .zero)
    super.init(frame: frame)
    _setupApperance()
    _layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    headerViewTouchesClosure?()
  }

}

extension LiveTableHeaderView {
  
  fileprivate func _setupApperance() {
    
    autoresizingMask = .init(rawValue: 0)
    backgroundColor = BBK_Main_Background_Color
    
    _arrowImageView.image = UIImage(named: "common_rightArrowShadow")
    
    _titleLabel.text = "正在直播"
    _titleLabel.textColor = UIColor.black
    _titleLabel.font = UIFont.systemFont(ofSize: 14)
    
    _detailLabel.text = "当前1024个直播, 进去看看"
    _detailLabel.textColor = UIColor(hexString: "#AAAAAA")
    
    addSubview(_iconImageView)
    addSubview(_arrowImageView)
    addSubview(_titleLabel)
    addSubview(_detailLabel)
  }
  
  fileprivate func _layoutSubviews() {
    
    _iconImageView.snp.makeConstraints { (make) in
      make.leading.equalTo(8)
      make.size.equalTo(20)
      make.centerY.equalTo(0)
    }
    
    _titleLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.leading.equalTo(_iconImageView.snp.trailing).offset(8)
    }
    
    _arrowImageView.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.trailing.equalTo(-8)
      make.size.equalTo(20)
    }
    
    _detailLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(0)
      make.trailing.equalTo(_arrowImageView.snp.leading).offset(-8)
    }
  }
  
}
