//
//  ShopModel.swift
//  PhotographBrowser
//
//  Created by BaoWanPei on 16/6/20.
//  Copyright © 2016年 BWP. All rights reserved.
//  商品模型

import UIKit

class ShopModel: NSObject {
    
    /// 高清URL476*620
    var pic_url	: String = ""
    /// 大图URL300*390
    var z_pic_url : String = ""
    /// 小图URL180*223
    var j_pic_url : String = ""
    
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    // 重写这个方法是为了过滤服务器返回的key
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
}
