//
//  PictureBrowserController.swift
//  PhotographBrowser
//
//  Created by BaoWanPei on 16/6/20.
//  Copyright © 2016年 BWP. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class PictureBrowserController: UIViewController {
    
    // MARK: - 定义属性
    var indexPath : NSIndexPath?
    var shopModels : [ShopModel]?
    
    /// CollectionView
    lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: PictureBrowserLayout())
    /// collectionViewCell重用标识
    let cellID = "collectionViewCellID"
    
    /// 关闭按钮
    lazy var closeButton : UIButton = UIButton()
    /// 保存图片按钮
    lazy var saveButton : UIButton = UIButton()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // 使得图片浏览时左右滑动,图片与图片之间有间距
        view.frame.size.width += 15
        
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        // 设置UI
        setupUI()
        
        // 滚动到对应的位置
//        guard let indexPath = indexPath else {return}
        collectionView.scrollToItemAtIndexPath(indexPath!, atScrollPosition: .Left, animated: true)
        
    }
}

// MARK: - 设置UI界面
extension PictureBrowserController {
    func setupUI() {
        // 设置collectionView相关属性
        setupCollectionView()
        
        // 设置closeButton/saveButton相关属性
        setupButton(closeButton, title: "关 闭", action: "closeButtonClick")
        setupButton(saveButton, title: "保 存", action: "savePictureButtonClick")
        
        // 设置子控件的位置
        setupSubViewsFrame()
        
        // 添加子控件到控制器view
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
    }
    //
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        // 注册cell
        collectionView.registerClass(PictureBrowserViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    //
    func setupButton(button : UIButton, title : String, action : String) {
        button.setTitle(title, forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(14)
        button.backgroundColor = UIColor.grayColor()
        button.addTarget(self, action: Selector(action), forControlEvents: .TouchUpInside)
    }

    //
    func setupSubViewsFrame() {
        // 设置collectionView的Frame
        collectionView.frame = view.bounds
        
        /// 屏幕宽度 和 高度
        let Screen_Width : CGFloat = UIScreen.mainScreen().bounds.width
        let Screen_Height : CGFloat = UIScreen.mainScreen().bounds.height
        let buttonW : CGFloat = 90
        let buttonH : CGFloat = 32
        let margin : CGFloat = 20
        let y = Screen_Height - 20 - 32
        closeButton.frame = CGRect(x: margin, y: y, width: buttonW, height: buttonH)
        let saveButtonX = Screen_Width - 90 - 20
        saveButton.frame = CGRect(x: saveButtonX, y: y, width: buttonW, height: buttonH)
    }
    
}

// MARK: - 按钮点击事件
extension PictureBrowserController {
    
    /// 关闭按钮 -> disMissViewController
    func closeButtonClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /// 保存图片按钮
    func savePictureButtonClick() {
        
        let alertController = UIAlertController(title: "温馨提示", message: "确定要保存图片吗?", preferredStyle: .Alert)
        let cancleAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "确定", style: .Destructive) { (_) -> Void in
            SVProgressHUD.showSuccessWithStatus("美图已保存成功")
            // 取出当前显示的图片
            let cell = self.collectionView.visibleCells().first as! PictureBrowserViewCell
            
            guard let image = cell.imageView.image else {return}
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        presentViewController(alertController, animated: true, completion: nil)
        alertController.addAction(cancleAction)
        alertController.addAction(confirmAction)
    }
    
}

// MARK: - UICollectionViewDataSource
extension PictureBrowserController : UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // ?? : 处理可选链,如果可选链中有一个可选类型没有值,那么直接使用 ?? 后面的值
        return self.shopModels?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! PictureBrowserViewCell
        
        // 设置cell的数据
        cell.shopModel = shopModels![indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PictureBrowserController : UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        closeButtonClick()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 清理内存
        SDImageCache.sharedImageCache().clearMemory()
    }
}

// MARK: - 实现disMissProtocol的代理方法
extension PictureBrowserController : PictureBrowserDismissProtocol {
    
    func getImageView() -> UIImageView {
        
        // 创建UIImageView对象
        let imageView = UIImageView()
        
        // 设置imageView的image
        let cell = collectionView.visibleCells().first as! PictureBrowserViewCell
        imageView.image = cell.imageView.image
        
        // 设置imageView的frame
        imageView.frame = cell.imageView.frame
        
        // 设置imageView的属性
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    func getIndexPath() -> NSIndexPath {
        
        // 获取当前显示的cell
        let cell = collectionView.visibleCells().first as! PictureBrowserViewCell
        
        return collectionView.indexPathForCell(cell)!
    }
}

