//
//  HomeViewCell.swift
//  PhotographBrowser
//
//  Created by BaoWanPei on 16/6/20.
//  Copyright © 2016年 BWP. All rights reserved.
//  UICollectionViewCell

import UIKit
import SDWebImage

class HomeViewCell: UICollectionViewCell {
    // MARK: - 定义属性
    @IBOutlet weak var imageView: UIImageView!
    /// 商品模型
    var shopModel : ShopModel? {
        didSet {// 当属性值发生改变就会调用
            
            // 1.校验模型是否有值
            guard let shopModel = shopModel else { return }
           
            // 2.取出图片的URL->String, 且校验url是否为空
            guard let url = NSURL(string: shopModel.j_pic_url) else { return }
            
            // 3.设置图片
            imageView.contentMode = .ScaleAspectFill
            let placeholderImage = UIImage(named: "empty_picture")
            imageView.sd_setImageWithURL(url, placeholderImage: placeholderImage)
        }
    }
    
    
}
