//
//  BBKCommonStyleCollectionViewLayout.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/11/1.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 普通类型 layout
// @since 1.0.0
// @author 赵林洋
public class BBKCommonStyleCollectionViewLayout: UICollectionViewLayout {

  public var itemHeight: CGFloat!
  public var itemCount: Int!
  
  fileprivate lazy var _attrsArray: [UICollectionViewLayoutAttributes] = {
    let lazilyCreatedArray = [UICollectionViewLayoutAttributes]()
    return lazilyCreatedArray
  }()
  
  public override func prepare() {
    super.prepare()
    _attrsArray.removeAll(keepingCapacity: false)
    
    for i in 0..<itemCount {
      let indexPath = IndexPath(row: i, section: 0)
      if let attrs = layoutAttributesForItem(at: indexPath) {
        _attrsArray.append(attrs)
      }
    }
  }
  
  public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    
    guard let collectionView = collectionView else { return nil }
//    边距
    let margin = BBK_App_Padding_8
//    宽度
    let width = (collectionView.st_width - 3 * margin) * 0.5
//    高度
    let height = itemHeight
//    创建布局属性
    let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//    行
    let row = indexPath.item / 2
//    列
    let col = indexPath.item % 2
//    坐标x值
    let x = CGFloat(col) * width + (CGFloat(col) + 1) * margin
//    坐标y值
    let y = CGFloat(row) * (height! + margin)
    
    attrs.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height!))
    
    return attrs
  }
  
  public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    return _attrsArray
  }
  
}
