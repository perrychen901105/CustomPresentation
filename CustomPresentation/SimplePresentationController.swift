//
//  SimplePresentationController.swift
//  CustomPresentation
//
//  Created by chenzhipeng on 14-10-21.
//  Copyright (c) 2014年 Fresh App Factory. All rights reserved.
//

import UIKit

// 1
class SimplePresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
   
    // 2
    var dimmingView: UIView = UIView()
    
    override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    
        // 3
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        dimmingView.alpha = 0.0
    }
    
    
    
}
