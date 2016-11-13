//
//  BBKRecommendSmallImageCollectionViewLayout.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/11/11.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

// 电视剧small layout
// @use RecommendSmallImageTableViewCell.swift
// @since 1.0.0
// @author 赵林洋
public class BBKRecommendSmallImageCollectionViewLayout: UICollectionViewFlowLayout {

  public override func prepare() {
    super.prepare()
    guard let collectionView = collectionView else { return }
    
    itemSize = CGSize(width: 140, height: collectionView.st_height)
    scrollDirection = .horizontal
    minimumInteritemSpacing = 0
    sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
  }
  
}
