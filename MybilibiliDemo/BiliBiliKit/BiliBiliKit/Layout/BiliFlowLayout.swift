//
//  BiliFlowLayout.swift
//  BiliBiliKit
//
//  Created by 宅总 on 16/10/21.
//  Copyright © 2016年 Zly. All rights reserved.
//

import UIKit

public class BiliFlowLayout: UICollectionViewFlowLayout {

  public override func prepare() {
    super.prepare()
    minimumLineSpacing = 0
    minimumInteritemSpacing = 0
    if let collectionView = collectionView {
      itemSize = collectionView.bounds.size
    }
    scrollDirection = .horizontal
  }
  
}
