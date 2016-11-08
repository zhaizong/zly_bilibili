//
//  RecommendNormalImageTableViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/11/6.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 普通四图tableView cell
// 普通 - 170高度  直播 - 167高度  番剧 - 166高度
// @since 1.0.0
// @author 赵林洋
fileprivate struct NormalImageCommons {
  static let CommonStyleCollectionViewCellID = "CommonStyleCollectionViewCellID"
  static let LiveStyleCollectionViewCellID = "LiveStyleCollectionViewCellID"
  static let BangumiStyleCollectionViewCellID = "BangumiStyleCollectionViewCellID"
}

class RecommendNormalImageTableViewCell: UITableViewCell {

  // MARK: - Property
  
  fileprivate var _collectionView: UICollectionView!
  
  // MARK: - Lifecycle
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    _setupApperance()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension RecommendNormalImageTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    return UICollectionViewCell()
  }
}

extension RecommendNormalImageTableViewCell {
  
  fileprivate func _setupApperance() {
    
    let layout = BBKCommonStyleCollectionViewLayout()
    layout.itemCount = 4
    layout.itemHeight = 170
    _collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    _collectionView.backgroundColor = UIColor.clear
    _collectionView.scrollsToTop = false
    
    _collectionView.register(RecommendNormalImageCollectionViewCell.self, forCellWithReuseIdentifier: NormalImageCommons.CommonStyleCollectionViewCellID)
    _collectionView.register(RecommendNormalImageLiveStyleCollectionViewCell.self, forCellWithReuseIdentifier: NormalImageCommons.LiveStyleCollectionViewCellID)
    _collectionView.register(RecommendNormalImageBangumiStyleCollectionViewCell.self, forCellWithReuseIdentifier: NormalImageCommons.BangumiStyleCollectionViewCellID)
  }
}














