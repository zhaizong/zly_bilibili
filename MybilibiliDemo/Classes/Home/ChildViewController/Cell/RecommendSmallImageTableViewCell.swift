//
//  RecommendSmallImageTableViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/6.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 电视剧small tableView Cell
// @since 1.0.0
// @author 赵林洋
fileprivate struct Commons {
  static let SmallCollectionViewCellIdentifier = "small_collection_view_cell_identifier"
}

class RecommendSmallImageTableViewCell: UITableViewCell {

  // MARK: - Property
  
  var model: [String: Any]? {
    didSet {
      guard let model = model, model.count != 0 else { return }
      if let bodys = model["body"] {
        let temps = bodys as! [[String: Any]]
        _bodys = temps
        _collectionView.reloadData()
      }
    }
  }
  
  fileprivate var _collectionView: UICollectionView!
  
  fileprivate var _bodys: [[String: Any]]
  
  // MARK: - Lifecycle
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    _bodys = []
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    _setupApperance()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension RecommendSmallImageTableViewCell: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return _bodys.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Commons.SmallCollectionViewCellIdentifier, for: indexPath) as! RecommendSmallImageTableViewCollectionViewCell
    cell.imageString = _bodys[indexPath.item]["cover"] as? String
    cell.titleString = _bodys[indexPath.item]["title"] as? String
    cell.detailInt = _bodys[indexPath.item]["index"] as? Int
    return cell
  }
}

extension RecommendSmallImageTableViewCell {
  
  fileprivate func _setupApperance() {
    
    let layout = BBKRecommendSmallImageCollectionViewLayout()
    _collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    _collectionView.register(RecommendSmallImageTableViewCollectionViewCell.self, forCellWithReuseIdentifier: Commons.SmallCollectionViewCellIdentifier)
    _collectionView.showsHorizontalScrollIndicator = false
    _collectionView.showsVerticalScrollIndicator = false
    _collectionView.scrollsToTop = false
    _collectionView.isScrollEnabled = true
    _collectionView.bounces = true
    _collectionView.dataSource = self
    
    contentView.addSubview(_collectionView)
    _collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top)
      make.bottom.equalTo(contentView.snp.bottom)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
    }
  }
}
