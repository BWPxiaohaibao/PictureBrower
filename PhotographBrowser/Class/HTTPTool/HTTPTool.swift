//
//  HTTPTool.swift
//  PhotographBrowser
//
//  Created by BaoWanPei on 16/6/20.
//  Copyright © 2016年 BWP. All rights reserved.
//  一套网络请求工具类

import UIKit
import AFNetworking
import SVProgressHUD

class HTTPTool: AFHTTPSessionManager {
    
    /// 将网络工具类设计成单例对象
    static let shareInstance : HTTPTool = {
        let tool = HTTPTool()
        tool.responseSerializer.acceptableContentTypes?.insert("text/html")
        return tool
    }()
    
    
    // http://mobapi.meilishuo.com/2.0/twitter/popular.json?offset=0&limit=30&access_token=b92e0c6fd3ca919d3e7547d446d9a8c2
    /// 获取首页数据
    func loadHomeData(offSet : Int, success : (resultArray : [[String : NSObject]]?, error : NSError?) -> ()) {
        // 1.获取请求的URLString
        let urlString = "http://mobapi.meilishuo.com/2.0/twitter/popular.json?offset=\(offSet)&limit=30&access_token=b92e0c6fd3ca919d3e7547d446d9a8c2"
        SVProgressHUD .showWithStatus("正在加载图片, 请稍后...")
        
        // 2.发送网络请求
        GET(urlString, parameters: nil, progress: nil, success: { (_, result) -> Void in
            // 1.将AnyObject?转成字典类型
            guard let resultDict = result as? [String : NSObject] else {
                print("获取数据失败")
                return
            }
            
            // 2.从字典中将数组取出
            let dictArray = resultDict["data"] as? [[String : NSObject]]
            
            // 3.将数据回调出去
            success(resultArray: dictArray, error: nil)
            SVProgressHUD.dismiss()
            }) { (_, error) -> Void in
                // 如果是取消了任务，就不算请求失败，就直接返回
                if error.code == NSURLErrorCancelled {return}
                if error.code == NSURLErrorTimedOut {// 请求超时
                    SVProgressHUD.showErrorWithStatus("网络请求超时,请稍后再试！")
                } else {
                    SVProgressHUD.showErrorWithStatus("数据加载失败")
                }
                success(resultArray: nil, error: error)
        }
    }
}

