//
//  HomeCollectionViewLayout.swift
//  PhotographBrowser
//
//  Created by BaoWanPei on 16/6/20.
//  Copyright © 2016年 BWP. All rights reserved.
//  自定义流水布局UICollectionViewFlowLayout

import UIKit

class HomeCollectionViewLayout: UICollectionViewFlowLayout {
    
    /// 屏幕宽度 和 高度
    let Screen_Width : CGFloat = UIScreen.mainScreen().bounds.width
    let Screen_Height : CGFloat = UIScreen.mainScreen().bounds.height
    
    override func prepareLayout() {
        super.prepareLayout()
        
        // 设置布局属性
        let margin : CGFloat = 12
        let cellWH : CGFloat = (Screen_Width - 4 * margin) / 3
        itemSize = CGSizeMake(cellWH, cellWH)
        minimumLineSpacing = margin
        minimumInteritemSpacing = margin
        collectionView?.contentInset = UIEdgeInsets(top: margin + 64, left: margin, bottom: margin, right: margin)
    }
}
