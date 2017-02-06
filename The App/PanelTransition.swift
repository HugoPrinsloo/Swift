////
////  PanelTransition.swift
////  The App
////
////  Created by Hugo Prinsloo on 2017/01/09.
////  Copyright © 2017 Hugo Prinsloo. All rights reserved.
////
//
//import UIKit
//
//@objc
//protocol PanelTransitionViewController {
////    func panelTransitionDetailViewForTransition(transition: PanelTransition) -> DetailedView!
//    @objc optional func panelTransitionWillAnimateTransition(transition: PanelTransition, presenting: Bool, isForeground: Bool)
//}
//
//class PanelTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
//
//    enum State {
//        case None
//        case Presenting
//        case Dismissing
//    }
//    
//    var state = State.None
//    var presentingController: UIViewController!
//    
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        return 0.6
//    }
//    
//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        presentingController = presenting
//        if presented is PanelTransitionViewController &&
//            presenting is PanelTransitionViewController {
//            state = .Presenting
//            return self
//        }
//        return nil
//    }
//    
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if dismissed is PanelTransitionViewController &&
//            presentingController is PanelTransitionViewController {
//            state = .Dismissing
//            return self
//        }
//        return nil
//    }
//    
//    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let duration = transitionDuration(using: transitionContext)
//        
//        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
//        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
//        let containerView = transitionContext.containerView
//        var backgroundViewController = fromViewController
//        var foregroundViewController = toViewController
//        if (state == .Dismissing) {
//            backgroundViewController = toViewController
//            foregroundViewController = fromViewController
//        }
//        
//        // get detail view from view controllers
//        let backgroundDetailViewMaybe = (backgroundViewController as? PanelTransitionViewController)?.panelTransitionDetailViewForTransition(transition: self)
//        let foregroundDetailViewMaybe = (foregroundViewController as? PanelTransitionViewController)?.panelTransitionDetailViewForTransition(transition: self)
//        
//        assert(backgroundDetailViewMaybe != nil, "Cannot find detail view in background view controller")
//        assert(foregroundDetailViewMaybe != nil, "Cannot find detail view in foreground view controller")
//        
//        let backgroundDetailView = backgroundDetailViewMaybe!
//        let foregroundDetailView = foregroundDetailViewMaybe!
//        
//        containerView.addSubview(backgroundViewController.view)
//        containerView.addSubview(foregroundViewController.view)
//        
//        if state == .Presenting {
//            foregroundViewController.view.alpha = 0
//        }
//        else {
//            foregroundViewController.view.alpha = 1
//        }
//        
//        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
//            [self]
//            if self.state == .Presenting {
//                foregroundViewController.view.alpha = 1
//            }
//            else {
//                foregroundViewController.view.alpha = 0
//            }
//            
//        }) { (finished) -> Void in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//   
//        // add views to container
//        containerView.addSubview(backgroundViewController.view)
//        
//        let wrapperView = UIView(frame: foregroundViewController.view.frame)
//        wrapperView.layer.shadowRadius = 5
//        wrapperView.layer.shadowOpacity = 0.3
//        wrapperView.layer.shadowOffset = .zero
//        
//        wrapperView.addSubview(foregroundViewController.view)
//        foregroundViewController.view.clipsToBounds = true
//        
//        containerView.addSubview(wrapperView)
//        
//        // perform animation
//        (foregroundViewController as? PanelTransitionViewController)?.panelTransitionWillAnimateTransition?(transition: self, presenting: state == .Presenting, isForeground: true)
//
//        backgroundDetailView.isHidden = true
//        
//        let backgroundFrame = containerView.convert(backgroundDetailView.frame, from: backgroundDetailView.superview)
//        let screenBounds = UIScreen.main.bounds
//        let scale = backgroundFrame.width / screenBounds.width
//        
//        if state == .Presenting {
//            wrapperView.transform = CGAffineTransform(scaleX: scale, y: scale)
//            foregroundDetailView.transitionProgress = 1
//        }
//        else {
//            wrapperView.transform = .identity
//        }
//        
//        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
//            [self]
//            if self.state == .Presenting {
//                wrapperView.transform = .identity
//                foregroundDetailView.transitionProgress = 0
//            }
//            else {
//                wrapperView.transform = CGAffineTransform(scaleX: scale, y: scale)
//                foregroundDetailView.transitionProgress = 1
//            }
//            
//        }) { (finished) -> Void in
//            backgroundDetailView.isHidden = false
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//    }
//}
