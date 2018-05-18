//
//  MasterCircularAnimation.swift
//  LawyerApp
//
//  Created by Adapting Social on 31/05/17.
//  Copyright © 2017 Adapting Social. All rights reserved.
//

import UIKit

class MasterCircularAnimation: NSObject,UIViewControllerTransitioningDelegate {

    let transition = CircularTransition()
    var startPoint = CGPoint.zero
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .present
        transition.startingPoint = startPoint
        transition.circleColor = UIColor.white
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = startPoint
        transition.circleColor = UIColor.white
        
        return transition
    }
}
