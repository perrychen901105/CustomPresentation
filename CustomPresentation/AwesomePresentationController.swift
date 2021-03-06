//
//  AwesomePresentationController.swift
//  CustomPresentation
//
//  Created by mac on 14-10-24.
//  Copyright (c) 2014年 Fresh App Factory. All rights reserved.
//

import UIKit

class AwesomePresentationController: UIPresentationController, UIViewControllerTransitioningDelegate {
    var dimmingView: UIView = UIView()
    var flagImageView: UIImageView = UIImageView(frame: CGRect(origin: CGPointZero, size: CGSize(width:160.0, height: 93.0)))
    var selectionObject: SelectionObject?
    var isAnimating = false
    
    override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        dimmingView.backgroundColor = UIColor.clearColor()
        flagImageView.contentMode = UIViewContentMode.ScaleAspectFill
        flagImageView.clipsToBounds = true
        flagImageView.layer.cornerRadius = 4.0
    }
    
    // accepts a selectiion object and uses it to configure the flagImageView with the necessary image and position
    func configureWithSelectionObject(selectionObject:SelectionObject) {
        self.selectionObject = selectionObject
        
        var image: UIImage = UIImage(named: selectionObject.country.imageName)
        flagImageView.image = image
        flagImageView.frame = selectionObject.originalCellPosition
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.OverFullScreen
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return containerView.bounds
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.frame = containerView.bounds
        presentedView().frame = containerView.bounds
    }
    
    // scales the flag based on the orientation and the available screen space of the device. you only call this method when the flagImageView is in its final resting place and the presentation animation has finished.
    func scaleFlagAndPositionFlag() {
        var flagFrame = flagImageView.frame
        var containerFrame = containerView.frame
        var originYMultiplier: CGFloat = 0.0
        var cellSize = selectionObject!.originalCellPosition.size
        
        if containerFrame.size.width > containerFrame.size.height {
            // Smaller sized flag
            flagFrame.size.width = cellSize.width * 1.5
            flagFrame.size.height = cellSize.height * 1.5
            
            originYMultiplier = 0.25
        } else {
            // Larger sized flag
            flagFrame.size.width = cellSize.width * 1.8
            flagFrame.size.height = cellSize.height * 1.8
            
            originYMultiplier = 0.333
        }
        
        flagFrame.origin.x = (containerFrame.size.width / 2) - (flagFrame.size.width / 2)
        flagFrame.origin.y = (containerFrame.size.height * originYMultiplier) - (flagFrame.size.height / 2)
        
        flagImageView.frame = flagFrame
        
    }
    
    
    func moveFlagToPresentedPosition(presentedPosition: Bool) {
        let containerFrame = containerView.frame
        
        // use scaleFlagAndPositionFlag() to adjust the image view if the animation has finished.
        if presentedPosition {
            // Expand flag and center
            scaleFlagAndPositionFlag()
        } else {
            // Move flag back to original position
            var flagFrame = flagImageView.frame
            flagFrame = selectionObject!.originalCellPosition
            flagImageView.frame = flagFrame
        }
    }
    
    // animates the flag from its origianl position in its owning cell in the collection view to an enlarged, and horizontally centered, position in th chrome
    func animateFlagToPresentedPosition(presentedPosition: Bool) {
        let coordinator = presentedViewController.transitionCoordinator()
        coordinator!.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
        self.moveFlagToPresentedPosition(presentedPosition)},
            completion: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in self.isAnimating = false
        })
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        // 1    assign true to isAnimating and move flagImageView to its original position
        isAnimating = true
        moveFlagToPresentedPosition(false)
        
        // 2    Add flagImageView as a subview of dimmingView, and then add dimmingView as a subView of containerView. Once the views are configured, call animateFlagToPresentedPostion(_:) to scale and position the flag alongside the animator's transition
        dimmingView.addSubview(flagImageView)
        containerView.addSubview(dimmingView)
        
        animateFlagToPresentedPosition(true)//
        animateFlagWithBounceToPresentation(true)
    }
    
    // 3    set isAnimating to true and animate the flag back to its original position alongside the animator's transition
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        isAnimating = true
//        animateFlagToPresentedPosition(false)
        animateFlagWithBounceToPresentation(false)
    }
 
    // add bounce to the animation when the flag image view moves
    func animateFlagWithBounceToPresentation(presentedPosition: Bool) {
        UIView.animateWithDuration(0.7, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.moveFlagToPresentedPosition(presentedPosition)
            }) { (value: Bool) -> Void in
            self.isAnimating = false
        }
    }
    
}
