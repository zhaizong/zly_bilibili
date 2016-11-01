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
  
  var entranceIconArray: [LiveEntranceIconModel] {
    didSet {
      _entranceIconDataSource.removeAll(keepingCapacity: false)
      _entranceIconDataSource = entranceIconArray
      
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
      
      _entranceIconDataSource.append(model1)
      _entranceIconDataSource.append(model2)
      
      collectionView.reloadData()
    }
  }
  
  // 数据源
  fileprivate lazy var _entranceIconDataSource: [LiveEntranceIconModel] = {
    let lazilyCreatedDataSource = [LiveEntranceIconModel]()
    return lazilyCreatedDataSource
  }()
  fileprivate var _block: ((_ selectedAreaID: LiveEntranceIconsViewAreaType) -> Void)?
  
  // MARK: - IBAction
  
  @IBAction func attentionAuthorButtonDidClick(_ sender: UIButton) {
    
    _block?(.attentionAuthor)
  }
  @IBAction func liveCenterButtonDidClick(_ sender: UIButton) {
    
    _block?(.liveCenter)
  }
  @IBAction func searchLiveButtonDidClick(_ sender: UIButton) {
    
    _block?(.searchLive)
  }
  
  // MARK: - Lifecycle
  
  class func liveEntranceIconsView(block: @escaping ((_ selectedAreaID: LiveEntranceIconsViewAreaType) -> Void)) -> LiveEntranceIconsView {
    
    let view = LiveEntranceIconsView()
    view._block = block
    return view
  }
  
  override init(frame: CGRect) {
    entranceIconArray = []
    super.init(frame: frame)
    
    _setupApperance()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
    
    return _entranceIconDataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Commons.cellID, for: indexPath) as! LiveEntranceIconsCollectionViewCell
    cell.iconUrl = _entranceIconDataSource[indexPath.item].entrance_icon.src
    cell.buttonName = _entranceIconDataSource[indexPath.item].name
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let model = _entranceIconDataSource[indexPath.item]
    if let temp = Int(model.idStr) {
      _block?(LiveEntranceIconsViewAreaType(rawValue: temp)!)
    }
  }
}
