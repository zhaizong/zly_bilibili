//
//  RecommendLargeImageTableViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/6.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 大图tableView cell
// @since 1.0.0
// @author 赵林洋
fileprivate struct Commons {
  static let LargeCollectionViewCellIdentifier = "large_collection_view_cell_identifier"
}

class RecommendLargeImageTableViewCell: UITableViewCell {

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

extension RecommendLargeImageTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Commons.LargeCollectionViewCellIdentifier, for: indexPath) as! RecommendLargeImageTableViewCollectionViewCell
    cell.model = _bodys[indexPath.item]
    return cell
  }
  
}

extension RecommendLargeImageTableViewCell {
  
  fileprivate func _setupApperance() {
    
    let layout = BBKRecommendLargeImageCollectionViewLayout()
    
    _collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    _collectionView.backgroundColor = BBK_Main_Background_Color
    _collectionView.showsHorizontalScrollIndicator = true
    _collectionView.showsVerticalScrollIndicator = true
    _collectionView.isScrollEnabled = true
    _collectionView.scrollsToTop = false
    _collectionView.dataSource = self
    _collectionView.delegate = self
    _collectionView.register(RecommendLargeImageTableViewCollectionViewCell.self, forCellWithReuseIdentifier: Commons.LargeCollectionViewCellIdentifier)
    
    contentView.addSubview(_collectionView)
    _collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top)
      make.bottom.equalTo(contentView.snp.bottom)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
    }
  }
  
}
