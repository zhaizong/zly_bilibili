//
//  LiveContentTableViewCell.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/31.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 直播内容视图tableViewCell
//
// @since 1.0.0
// @author 赵林洋
fileprivate struct Commons {
  static let LiveCellCollectionViewCellIdentifier = "livecellcollectionviewcellidentifier"
}

class LiveContentTableViewCell: UITableViewCell {

  // MARK: - Property
  
  var liveTableViewCellDidSelectedClosure: ((_ liveSource: BBCLiveSource) -> Void)?
  
  fileprivate var _collectionView: UICollectionView!
  
  fileprivate var _livePartition: BBCLivePartition!
  fileprivate var _liveSources: [BBCLiveSource]
  
  func setupCellDataSource(_ livePartition: BBCLivePartition?, liveSources: [BBCLiveSource]?) {
    guard let livePartition = livePartition, let liveSources = liveSources, liveSources.count != 0 else { return }
    _liveSources.removeAll(keepingCapacity: false)
//    直播分区数据源
    _livePartition = livePartition
//    直播数据源
    _liveSources = liveSources
//    刷新数据源
    _collectionView.reloadData()
  }
  
  // MARK: - Lifecycle
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    _liveSources = []
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    _setupApperance()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension LiveContentTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard indexPath.item < 4 else { return UICollectionViewCell() }
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Commons.LiveCellCollectionViewCellIdentifier, for: indexPath) as! LiveContentCollectionViewCell

    cell.avatarUrlString = _livePartition.src
    cell.coverUrlString = _liveSources[indexPath.item].cover["src"] as? String
    cell.nameString = _liveSources[indexPath.item].owner["name"] as? String
    cell.viewerString = "\(_liveSources[indexPath.item].online)"
    cell.titleString = _liveSources[indexPath.item].titleString
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    liveTableViewCellDidSelectedClosure?(_liveSources[indexPath.item])
  }
}

extension LiveContentTableViewCell {
  
  fileprivate func _setupApperance() {
    
    selectionStyle = .none
    backgroundColor = BBK_Main_Background_Color
    
    let layout = BBKCommonStyleCollectionViewLayout()
    let width = (BBK_Screen_Width - 3 * BBK_App_Padding_8) * 0.5
    let height = floor(width * 180 / 320 + 47)
    layout.itemHeight = height
    layout.itemCount = 4
    _collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    _collectionView.register(LiveContentCollectionViewCell.self, forCellWithReuseIdentifier: Commons.LiveCellCollectionViewCellIdentifier)
    _collectionView.scrollsToTop = false
    _collectionView.isPrefetchingEnabled = true
    _collectionView.backgroundColor = BBK_Main_Background_Color
    _collectionView.dataSource = self
    _collectionView.delegate = self
    contentView.addSubview(_collectionView)
    _collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top)
      make.bottom.equalTo(contentView.snp.bottom)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
    }
  }
}
