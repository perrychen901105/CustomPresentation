//
//  AwesomeTransitioner.swift
//  CustomPresentation
//
//  Created by mac on 14-10-24.
//  Copyright (c) 2014年 Fresh App Factory. All rights reserved.
//

import UIKit

class AwesomeTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var selectedObject: SelectionObject?
    
    init(selectedObject: SelectionObject) {
        super.init()
        self.selectedObject = selectedObject
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        var presentationController = AwesomePresentationController(presentedViewController: presented, presentingViewController: presenting)
        presentationController.configureWithSelectionObject(selectedObject!)
        return presentationController
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var animationController = AwesomeAnimatedTransitioning(selectedObject: selectedObject!, isPresentation: true)
        return animationController
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var animationController = AwesomeAnimatedTransitioning(selectedObject: selectedObject!, isPresentation: false)
        return animationController
    }
    
}

class AwesomeAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresentation: Bool = false
    var selectedObject: SelectionObject?
    
    init(selectedObject: SelectionObject, isPresentation: Bool) {
        self.selectedObject = selectedObject
        self.isPresentation = isPresentation
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.7
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromViewController!.view
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewController!.view
        
        var containerView: UIView = transitionContext.containerView()
        
        if isPresentation {
            containerView.addSubview(toView)
        }
        
        let animatingViewController = isPresentation ? toViewController : fromViewController
        var animatingView = animatingViewController!.view
        
        animatingView.frame = transitionContext.finalFrameForViewController(animatingViewController!)
        var appearedFrame = transitionContext.finalFrameForViewController(animatingViewController!)
        var dismissedFrame = appearedFrame
        dismissedFrame.origin.y += dismissedFrame.size.height
        
        var initialFrame = isPresentation ? dismissedFrame : appearedFrame
        var finalFrame = isPresentation ? appearedFrame : dismissedFrame
        
        animatingView.frame = initialFrame
        
        // check if the animator's animation is presenting, if so, set the countriesViewControler to fromViewController ,otherwise set it to toViewController. Next , if the animation is a dismissal then hide the cell's image view.
        var countriesViewController: CountriesViewController = (isPresentation ? fromViewController : toViewController) as CountriesViewController
        
        if !isPresentation {
            countriesViewController.hideImage(true, indexPath: selectedObject!.selectedCellIndexPath)
        }
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.BeginFromCurrentState, animations: {animatingView.frame = finalFrame}, completion: {(value: Bool) in
            if !self.isPresentation{
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            } else {
                transitionContext.completeTransition(true)
            }
        })
        
        
        
    }
    
}

