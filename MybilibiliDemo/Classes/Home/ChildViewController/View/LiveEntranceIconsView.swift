//
//  LiveEntranceIconsView.swift
//  MybilibiliDemo
//
//  Created by 宅总 on 16/10/29.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 入口图标View
// @since 1.0.0
// @author 赵林洋
fileprivate struct Commons {
  static let cellID = "LiveEntranceIconsCollectionViewCell"
}

struct LiveEntranceIconModel {
  var idStr: String! // id
  var name: String! // 名字
  var entrance_icon: RealEntranceIconModel! // 图标对象
}
struct RealEntranceIconModel {
  var src: String! // 图标来源(url)
  var height: String! // 图标高度
  var width: String! // 图标宽度
}

class LiveEntranceIconsView: UIView {

  // MARK: - IBOutlet
  
  @IBOutlet weak var collectionView: UICollectionView! // 入口图标视图
  @IBOutlet weak var bottomToolBar: UIView! // 底部toolBar
  @IBOutlet weak var attentionAuthorBtn: UIButton! // 关注主播按钮
  @IBOutlet weak var liveCenterBtn: UIButton! // 直播中心按钮
  @IBOutlet weak var searchLiveBtn: UIButton! // 搜索直播按钮
  
  // MARK: - Property
  
  fileprivate var entranceIconArray: [LiveEntranceIconModel] {
    didSet {
//      _entranceIconDataSource.removeAll(keepingCapacity: false)
//      _entranceIconDataSource = entranceIconArray
      
      var model1 = LiveEntranceIconModel()
      var srcModel1 = RealEntranceIconModel()
      model1.idStr = "10086"
      model1.name = "全部分类"
      srcModel1.src = "live_partitionEntrance-1"
      model1.entrance_icon = srcModel1
      
      var model2 = LiveEntranceIconModel()
      var srcModel2 = RealEntranceIconModel()
      model2.idStr = "10087"
      model2.name = "全部直播"
      srcModel2.src = "live_partitionEntrance0"
      model2.entrance_icon = srcModel2
      
//      _entranceIconDataSource.append(model1)
//      _entranceIconDataSource.append(model2)
      
      collectionView.reloadData()
    }
  }
  
  var entranceIcons: [BBCLiveEntrance]? {
    didSet {
      guard let entranceIcons = entranceIcons, entranceIcons.count != 0 else { return }
      _entranceIcons = entranceIcons
      collectionView.reloadData()
    }
  }
  
  var entranceViewDidSelectedClosure: ((_ selectedAreaID: LiveEntranceIconsViewAreaType) -> Void)?
  
  // 数据源
  fileprivate var _entranceIcons: [BBCLiveEntrance]
  
  // MARK: - IBAction
  
  @IBAction func attentionAuthorButtonDidClick(_ sender: UIButton) {
    
    entranceViewDidSelectedClosure?(.attentionAuthor)
  }
  @IBAction func liveCenterButtonDidClick(_ sender: UIButton) {
    
    entranceViewDidSelectedClosure?(.liveCenter)
  }
  @IBAction func searchLiveButtonDidClick(_ sender: UIButton) {
    
    entranceViewDidSelectedClosure?(.searchLive)
  }
  
  // MARK: - Lifecycle
  
  class func liveEntranceIconsView() -> LiveEntranceIconsView {
    
//    return Bundle.main.loadNibNamed("liveEntranceIconsView", owner: self, options: nil)?.last as! LiveEntranceIconsView!
    return Bundle.main.loadNibNamed("LiveEntranceIconsView", owner: self, options: nil)?.last as! LiveEntranceIconsView
  }
  
  required init?(coder aDecoder: NSCoder) {
    entranceIconArray = []
    _entranceIcons = []
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    _setupApperance()
  }

}

extension LiveEntranceIconsView {
  
  fileprivate func _setupApperance() {
    
    autoresizingMask = .init(rawValue: 0)
    backgroundColor = BBK_Main_Background_Color
    
    collectionView.backgroundColor = BBK_Main_Background_Color
    collectionView.scrollsToTop = false
    
    bottomToolBar.layer.cornerRadius = 4
    bottomToolBar.layer.masksToBounds = false
    
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: BBK_Screen_Width / 4, height: BBK_Screen_Width / 4)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    collectionView.collectionViewLayout = layout
    collectionView.register(LiveEntranceIconsCollectionViewCell.self, forCellWithReuseIdentifier: Commons.cellID)
  }
}

extension LiveEntranceIconsView: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return _entranceIcons.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Commons.cellID, for: indexPath) as! LiveEntranceIconsCollectionViewCell
    cell.iconUrl = _entranceIcons[indexPath.item].entranceIcon.src
    cell.buttonName = _entranceIcons[indexPath.item].name
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let id = Int(_entranceIcons[indexPath.item].idString)!
    entranceViewDidSelectedClosure?(LiveEntranceIconsViewAreaType(rawValue: id)!)
  }
}
