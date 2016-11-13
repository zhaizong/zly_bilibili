//
//  BBKRecommendLargeImageCollectionViewLayout.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/11/10.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 大图类型 layout
// RecommendLargeImageTableViewCell.swift
// @since 1.0.0
// @author 赵林洋
public class BBKRecommendLargeImageCollectionViewLayout: UICollectionViewLayout {

  fileprivate lazy var _attrsArray: [UICollectionViewLayoutAttributes] = {
    let lazilyCreatedArray = [UICollectionViewLayoutAttributes]()
    return lazilyCreatedArray
  }()
  
  override public func prepare() {
    super.prepare()
    
    _attrsArray.removeAll(keepingCapacity: false)
    
    let indexPath = IndexPath(row: 0, section: 0)
    
    if let attrs = layoutAttributesForItem(at: indexPath) {
      _attrsArray.append(attrs)
    }
  }
  
  override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    
    guard let collectionView = collectionView else { return nil }
    
    let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
    
    let margin = BBK_App_Padding_8
    
    let width = collectionView.st_width - 2 * margin
    
    let height: CGFloat = 120
    
    let x = margin
    
    let y: CGFloat = 0
    
    attrs.frame = CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    
    return attrs
  }
  
  override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    return _attrsArray
  }
  
}
