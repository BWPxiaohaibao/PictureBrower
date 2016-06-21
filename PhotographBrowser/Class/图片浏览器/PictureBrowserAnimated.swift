//
//  PictureBrowserAnimated.swift
//  PhotographBrowser
//
//  Created by BaoWanPei on 16/6/21.
//  Copyright © 2016年 BWP. All rights reserved.
//  实现自定义转场动画的代理

import UIKit

/// 图片浏览器弹出代理(目的:获取ImageView,开始位置,结束位置)
protocol PictureBrowserPresentProtocol : class {
    func getImageView(indexPath : NSIndexPath) -> UIImageView
    func getCollectionViewCell(indexPath : NSIndexPath) -> HomeViewCell?
    func getStartRect(indexPath : NSIndexPath) -> CGRect
    func getEndRect(indexPath : NSIndexPath) -> CGRect
}

/// 图片浏览器消失代理
protocol PictureBrowserDismissProtocol : class {
    func getImageView() -> UIImageView
    func getIndexPath() -> NSIndexPath
}


class PictureBrowserAnimated: NSObject {
    // MARK: - 定义属性
    var isPresent : Bool = false
    var indexPath : NSIndexPath?

    
    weak var presentDelegate : PictureBrowserPresentProtocol?
    weak var dismissDelegate : PictureBrowserDismissProtocol?
    
}

// MARK: - 实现自定义转场动画的代理方法
extension PictureBrowserAnimated : UIViewControllerTransitioningDelegate {
    
    // 告诉弹出的动画交给谁去管理
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = true
        
        return self
    }
    
    // 告诉消失的动画交给谁去管理
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresent = false
        
        return self
    }
}


// MARK: - 实现自定义转场的动画
extension PictureBrowserAnimated : UIViewControllerAnimatedTransitioning {
    
    // 决定动画持续时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.8
    }
    
    // 决定动画如何实现
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        /// 动画持续时间
        let duration = transitionDuration(transitionContext)
        
        if isPresent {// 弹出动画
            
            // nil值校验
            guard let indexPath = indexPath, presentDelegate = presentDelegate else {
                return
            }
            
            // 获取弹出的View
            let presentView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            // 这里少错处理,先添加presentView让其alpha = 0; 然后再动画执行完毕再让其alpha =1; 目的是从小图变大图的时候解决闪烁BUG
            transitionContext.containerView()?.addSubview(presentView)
            presentView.alpha = 0
            
            // 执行动画
            // >获取需要执行动画的imageView 且 添加到containerView
            let imageView = presentDelegate.getImageView(indexPath)
            transitionContext.containerView()?.addSubview(imageView)
            
            // >设置imageBView的起始位置
            imageView.frame = presentDelegate.getStartRect(indexPath)

            // >执行动画
            transitionContext.containerView()?.backgroundColor = UIColor.blackColor()
            UIView.animateWithDuration(duration, animations: { () -> Void in
                imageView.frame = presentDelegate.getEndRect(indexPath)
                }, completion: { (_) -> Void in
                    // 将弹出的View添加到containerView中
                    presentView.alpha = 1
                    transitionContext.containerView()?.backgroundColor = UIColor.clearColor()
                    imageView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
            
        }else {
            // 0.控制校验
            guard let dismissDelegate = dismissDelegate, presentDelegate = presentDelegate else {
                return
            }
            
            // 1.取出消失的View
            let dismissView = transitionContext.viewForKey(UITransitionContextFromViewKey)

            // 2.执行动画
            // 2.1.获取执行动画的imageView
            let imageView = dismissDelegate.getImageView()
            transitionContext.containerView()?.addSubview(imageView)
            
            // 2.2.取出indexPath
            let indexPath = dismissDelegate.getIndexPath()
            
            // 2.3.获取结束的位置
            let endRect = presentDelegate.getStartRect(indexPath)
            
            dismissView?.alpha = endRect == CGRectZero ? 1.0 : 0.0
            
            // 获取当前IndexPath对应decell
            // 判断当前cell如果为空, 说明cell还没有完全显示在当前控制器View上,所以1.5秒内dismissView.alpha = 0.0, 且动画完成前让cell的alpah = 0.0 (目的: 防止浏览器cell锁防盗HomeViewCell大小时看到重叠效果)
            guard let cell = presentDelegate.getCollectionViewCell(indexPath) else {
                UIView .animateWithDuration(duration, animations: { () -> Void in
//                    imageView.removeFromSuperview()
                    dismissView?.alpha = 0.0
                    }, completion: { (_) -> Void in
                        transitionContext.completeTransition(true)
                })
                return
            }
            cell.alpha = 0.0
            // 2.4.执行动画
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                if endRect == CGRectZero {
                    imageView.removeFromSuperview()
                    dismissView?.alpha = 0.0
                } else {
                    imageView.frame = endRect
                }
                
                }, completion: { (_) -> Void in
                    cell.alpha = 1.0
                    dismissView?.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }

    }
}

