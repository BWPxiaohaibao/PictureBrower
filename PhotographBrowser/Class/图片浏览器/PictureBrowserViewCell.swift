//
//  PictureBrowserViewCell.swift
//  PhotographBrowser
//
//  Created by BaoWanPei on 16/6/21.
//  Copyright © 2016年 BWP. All rights reserved.
//

import UIKit
import SDWebImage

class PictureBrowserViewCell: UICollectionViewCell {
    
    // MARK: - 定义属性
    lazy var imageView : UIImageView = UIImageView()

    var shopModel : ShopModel? {
        didSet {
            // 1.nil值校验
            guard let shopModel = shopModel else {
                return
            }
            
            // 2.取出image对象
            var image = SDWebImageManager.sharedManager().imageCache.imageFromMemoryCacheForKey(shopModel.j_pic_url)
            if image == nil {
                image = UIImage(named: "empty_picture")
            }
            
            // 3.根据image计算出imageView的Frame
            imageView.frame = calculateImageViewFrame(image)
            
            // 4.设置imageView的图片
            guard let url = NSURL(string: shopModel.pic_url) else {
                imageView.image = image
                return
            }
//            imageView.contentMode = .ScaleAspectFill
            // 添加手势
//            let tap1 = UITapGestureRecognizer(target: self, action: Selector("tap:"))
//            tap1.numberOfTapsRequired = 1
//            imageView.addGestureRecognizer(tap1)
//            let tap2 = UITapGestureRecognizer(target: self, action: Selector("tap:"))
//            tap2.numberOfTapsRequired = 2
//            imageView.addGestureRecognizer(tap2)
//            //开启imageView的用户交互
//            imageView.userInteractionEnabled = true
            
            imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: shopModel.j_pic_url)) { (image, _, _, _) -> Void in
                
                self.imageView.frame = calculateImageViewFrame(image)
            }
        }
    }
    
    
    // MARK: - 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
    }
    
    // required : 如果要实现父类的某一个构造函数,那么必须同时实现使用required修饰的构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.addSubview(imageView)
    }
    
}

// MARK: - 手势-双击放大图片
extension PictureBrowserViewCell {
    func tap(tap : UITapGestureRecognizer) {
        if tap.numberOfTapsRequired == 2 {
            
            print("11111111111111")
        }else if tap.numberOfTapsRequired == 1 {
        
            print("22222222222")
        }
    }
}



