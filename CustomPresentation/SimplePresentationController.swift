//
//  SimplePresentationController.swift
//  CustomPresentation
//
//  Created by chenzhipeng on 14-10-21.
//  Copyright (c) 2014年 Fresh App Factory. All rights reserved.
//

import UIKit

// 1 adapt the UIAdaptivePresentationControllerDelegate protocol
class SimplePresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
   
    // 2   create a UIView property called dimmingView that will be used as the chrome
    var dimmingView: UIView = UIView()
    
    override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    
        // 3
        /*
        *   set the background color and alpha value of dimmingView
        */
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        dimmingView.alpha = 0.0
    }
    
    override func presentationTransitionWillBegin() {
        // 1
        /*
        *   set the frame of dimmingView to the bounds of the container view, its alpha to 0.0, and insert the view into the container view.
            the container view is the view where the presentation will take place, and is a property of UIPresentationController.
        */
        dimmingView.frame = self.containerView.bounds
        dimmingView.alpha = 0.0
        containerView.insertSubview(dimmingView, atIndex: 0)
        
        // 2
        /*
        *   set the local variable coordinator to the presented view controller's transition coordinator. The transition coordinator is in charge of animating both the presentation and dimissal of the content.
        */
        let coordinator = presentedViewController.transitionCoordinator()
        if (coordinator != nil) {
            // 3
            /*
            * you can perform addtional animattions alongside of the presentation animation
            */
            coordinator!.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha = 1.0
            }, completion: nil)
        } else {
            dimmingView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator()
        if (coordinator != nil) {
            coordinator!.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha = 0.0
            }, completion: nil)
        } else {
            dimmingView.alpha = 0.0
        }
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView.bounds
        presentedView().frame = containerView.bounds
    }
    
    override func shouldPresentInFullscreen() -> Bool {
        return true
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // indicating that the presented view should cover the full screen
        // over full screen will allow the views under the presented view controller to be visible
        return UIModalPresentationStyle.OverFullScreen
    }
    
}
