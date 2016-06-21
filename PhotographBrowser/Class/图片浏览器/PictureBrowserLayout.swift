//
//  PictureBrowserLayout.swift
//  PhotographBrowser
//
//  Created by BaoWanPei on 16/6/21.
//  Copyright © 2016年 BWP. All rights reserved.
//

import UIKit

class PictureBrowserLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        // layout
        itemSize = (collectionView?.bounds.size)!;
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .Horizontal// 设置水平滚动
        
        // 设置collectionView
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.pagingEnabled = true
    }
    
}
