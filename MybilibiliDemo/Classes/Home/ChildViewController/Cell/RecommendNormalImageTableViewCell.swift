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
  
  var model: [String: Any]? {
    didSet {
      guard let model = model, model.count != 0 else { return }
      _type = model["type"] as! String
      _body.removeAll(keepingCapacity: false)
      _body = model["body"] as! [[String: Any]]
      
      _collectionView.reloadData()
    }
  }
  
  fileprivate var _collectionView: UICollectionView!
  
  fileprivate var _type: String
  fileprivate var _body: [[String: Any]]
  
  // MARK: - Lifecycle
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    _type = ""
    _body = []
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
    
    if _type == "region" || _type == "recommend" {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalImageCommons.CommonStyleCollectionViewCellID, for: indexPath) as! RecommendNormalImageCollectionViewCell
      cell.titleString = _body[indexPath.item]["title"] as? String
      cell.playCountString = _body[indexPath.item]["play"] as? String
      cell.danmukuCountString = _body[indexPath.item]["danmaku"] as? String
      cell.imageViewString = _body[indexPath.item]["cover"] as? String
      return cell
      
    } else if _type == "live" {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalImageCommons.LiveStyleCollectionViewCellID, for: indexPath) as! RecommendNormalImageLiveStyleCollectionViewCell
      cell.authorNameString = _body[indexPath.item]["name"] as? String
      cell.onlineCountString = _body[indexPath.item]["online"] as? String
      cell.titleString = _body[indexPath.item]["title"] as? String
      cell.iconImageString = _body[indexPath.item]["face"] as? String
      cell.contentImageString = _body[indexPath.item]["cover"] as? String
      return cell
      
    } else if _type == "bangumi" {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NormalImageCommons.BangumiStyleCollectionViewCellID, for: indexPath) as! RecommendNormalImageBangumiStyleCollectionViewCell
      cell.titleString = _body[indexPath.item]["title"] as? String
      cell.imageViewString = _body[indexPath.item]["cover"] as? String
      return cell
      
    }
    
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
    _collectionView.showsVerticalScrollIndicator = true
    _collectionView.showsHorizontalScrollIndicator = true
    _collectionView.isScrollEnabled = true
    _collectionView.bounces = true
    _collectionView.dataSource = self
    _collectionView.delegate = self
    
    _collectionView.register(RecommendNormalImageCollectionViewCell.self, forCellWithReuseIdentifier: NormalImageCommons.CommonStyleCollectionViewCellID)
    
    _collectionView.register(RecommendNormalImageLiveStyleCollectionViewCell.self, forCellWithReuseIdentifier: NormalImageCommons.LiveStyleCollectionViewCellID)
    
    _collectionView.register(RecommendNormalImageBangumiStyleCollectionViewCell.self, forCellWithReuseIdentifier: NormalImageCommons.BangumiStyleCollectionViewCellID)
    
    contentView.addSubview(_collectionView)
    _collectionView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView.snp.top)
      make.bottom.equalTo(contentView.snp.bottom)
      make.leading.equalTo(contentView.snp.leading)
      make.trailing.equalTo(contentView.snp.trailing)
    }
  }
}














