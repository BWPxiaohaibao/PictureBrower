//
//  HomeViewController.swift
//  PhotographBrowser
//
//  Created by BaoWanPei on 16/6/20.
//  Copyright © 2016年 BWP. All rights reserved.
//  展示商品的图片信息

import UIKit
import SDWebImage

private let cellID = "CollectionViewCell"

class HomeViewController: UICollectionViewController {

    // MARK: - 定义属性
    lazy var shopModels : [ShopModel] = [ShopModel]()
    
    let pictureAnimated : PictureBrowserAnimated = PictureBrowserAnimated()
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView?.backgroundColor = UIColor.whiteColor()
        
        // 第一次加载首页数据(获取最前面的数据arrayOffSet = 0)
        loadData(0)
    }
}

// MARK: - 请求网络数据
extension HomeViewController {
    func loadData(arrayOffSet : Int) {
        HTTPTool.shareInstance.loadHomeData(arrayOffSet) { (resultArray, error) -> () in
            // 1.错误校验
            if error != nil {
                print("数据请求失败")
                return
            }
            // 2.取出可选类型中的数据
            guard let resultArray = resultArray else { return }
            // 3.遍历数组,将数组中的字典转成模型对象
            for dict in resultArray {
                // 将字典数组转为模型数组
                self.shopModels.append(ShopModel(dict: dict))
            }
            //4.刷新表格
            self.collectionView?.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.shopModels.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! HomeViewCell
        
        cell.shopModel = shopModels[indexPath.row]
        
        // 加载更多数据
        if indexPath.row == (shopModels.count - 1) {
            loadData(shopModels.count)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate / 签订自定义转场动画delegate
extension HomeViewController {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 创建图片浏览控制器
        let pictureBrowserVC = PictureBrowserController()
        // 传递数据
        pictureBrowserVC.shopModels = shopModels
        pictureBrowserVC.indexPath = indexPath
    
        // 设置photoBrowser - Modal出来时的弹出动画(基本转场动画)
//        pictureBrowserVC.modalTransitionStyle = .FlipHorizontal   // 翻转
//        pictureBrowserVC.modalTransitionStyle = .PartialCurl      // 翻页
//        pictureBrowserVC.modalTransitionStyle = .CrossDissolve    // 淡入淡出
//        pictureBrowserVC.modalTransitionStyle = .CoverVertical    // 默认
        
        // 自定义转场动画
        // 设置所需数据
        pictureAnimated.indexPath = indexPath
        pictureAnimated.presentDelegate = self
        pictureAnimated.dismissDelegate = pictureBrowserVC
        
        pictureBrowserVC.modalPresentationStyle = .Custom
        pictureBrowserVC.transitioningDelegate = pictureAnimated
        
        presentViewController(pictureBrowserVC, animated: true, completion: nil)
        print("点击了 第\(indexPath.row)")
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // 清理内存
        SDImageCache.sharedImageCache().clearMemory()
    }
}

// MARK: - 实现PresentProtocol方法
extension HomeViewController : PictureBrowserPresentProtocol {
    
    // 获取当前cell
    func getCollectionViewCell(indexPath: NSIndexPath) -> HomeViewCell? {
        
        var cell = collectionView?.cellForItemAtIndexPath(indexPath) as? HomeViewCell
        
        if cell == nil {
            collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
            cell = collectionView?.cellForItemAtIndexPath(indexPath) as? HomeViewCell
            return cell
        }
        
        return cell!
    }
    
    // 获取当前cell indexPath的imageView
    func getImageView(indexPath: NSIndexPath) -> UIImageView {
        let imageView = UIImageView()
        
        let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! HomeViewCell
        
        imageView.image = cell.imageView.image
        
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    // 获取cell的起始位置
    func getStartRect(indexPath: NSIndexPath) -> CGRect {
        
        guard let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? HomeViewCell else {
            
            return CGRectZero
        }
        
        // 把当前cell的frame转换成所在屏幕的frame
        let startRect = collectionView!.convertRect(cell.frame, toCoordinateSpace: UIApplication.sharedApplication().keyWindow!)
        
        return startRect
    }
    // 获取cell的终点位置
    func getEndRect(indexPath: NSIndexPath) -> CGRect {
        
        // 获取当前所显示的cell
        let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! HomeViewCell
        
        // 获取image
        let image = cell.imageView.image
        
        return calculateImageViewFrame(image!)
    }
}









