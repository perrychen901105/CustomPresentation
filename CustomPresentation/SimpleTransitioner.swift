//
//  SimpleTransitioner.swift
//  CountryFunFacts
//
//  Created by mac on 14-10-23.
//  Copyright (c) 2014年 Fresh App Factory. All rights reserved.
//

import UIKit

class SimpleTransitioner: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresentation: Bool = false
    

    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // UITransitonContextFromViewControllerKey which is the view controller that's visible at the start of the transition and the UITransitionContextToViewControllerKey which is used to retrieve the view controller which will be visible at the end of the transition.
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let fromView = fromViewController!.view
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let toView = toViewController!.view
        
        var containerView: UIView = transitionContext.containerView()
        if isPresentation {
            containerView.addSubview(toView)
        }
        
        // 1    Determine which view controller to animate based on the value of isPresentation
        var animatingViewController = isPresentation ? toViewController : fromViewController
        var animatingView = animatingViewController!.view
        // 2
        var appearedFrame = transitionContext.finalFrameForViewController(animatingViewController!)
        var dismissedFrame = appearedFrame
        dismissedFrame.origin.y += dismissedFrame.size.height
        // 3
        let initialFrame = isPresentation ? dismissedFrame : appearedFrame
        let finalFrame = isPresentation ? appearedFrame : dismissedFrame
        animatingView.frame = initialFrame
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 300.0,
            initialSpringVelocity: 5.0, options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.BeginFromCurrentState, animations: { animatingView.frame = finalFrame
            }, completion: {
                (value: Bool) in
                if !self.isPresentation {
                    fromView.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
        })
        

    }
}

class SimpleTransitioningDelegate:NSObject, UIViewControllerTransitioningDelegate {
//    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
//    }
}


