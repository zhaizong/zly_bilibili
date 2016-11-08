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
  
  var lives: [[String: Any]]? { // 直播数据源
    didSet {
      guard let lives = lives, lives.count > 0 else { return }
      _lives = lives
//      刷新数据源
      _collectionView.reloadData()
    }
  }
  
  var liveTableViewCellClosureDidClick: (() -> Void)?
  
  fileprivate var _collectionView: UICollectionView!
  
  fileprivate var _lives: [[String: Any]]
  
  // MARK: - Lifecycle
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    _lives = []
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
    
    let tempDic = _lives[indexPath.item]
    cell.avatarUrlString = (tempDic["owner"] as! [String: Any])["face"] as? String
    cell.coverUrlString = (tempDic["cover"] as! [String: Any])["src"] as? String
    cell.nameString = (tempDic["owner"] as! [String: Any])["name"] as? String
    cell.viewerString = "\(tempDic["online"] as? Int)"
    cell.titleString = tempDic["title"] as? String
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    
  }
}

extension LiveContentTableViewCell {
  
  fileprivate func _setupApperance() {
    
    autoresizingMask = .init(rawValue: 0)
    selectionStyle = .none
    backgroundColor = BBK_Main_Background_Color
    
    let layout = BBKCommonStyleCollectionViewLayout()
    let width = (BBK_Screen_Width - 3 * BBK_App_Padding_8) * 0.5
    let height = floor(width * 180 / 320 + 47)
    layout.itemHeight = height
    layout.itemCount = 4
    _collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    _collectionView.register(LiveContentCollectionViewCell.self, forCellWithReuseIdentifier: Commons.LiveCellCollectionViewCellIdentifier)
  }
}
