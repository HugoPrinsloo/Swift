////
////  DetailedViewController.swift
////  The App
////
////  Created by Hugo Prinsloo on 2017/01/09.
////  Copyright © 2017 Hugo Prinsloo. All rights reserved.
////
//
//import UIKit
//
//class DetailedViewController: UIViewController {
//        
//    let contentView = UIView()
//    
//    @IBOutlet weak var detailButton: UIButton!
////    @IBOutlet weak var detailView: DetailedView!
//
//    private let kContentViewTopOffset: CGFloat = 64
//    private let kContentViewBottomOffset: CGFloat = 64
//    private let kContentViewAnimationDuration: TimeInterval = 1.4
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        contentView.backgroundColor = UIColor.white
//        contentView.frame = CGRect(x: 0, y: kContentViewTopOffset, width: view.bounds.width, height: view.bounds.height-kContentViewTopOffset)
//        contentView.layer.shadowRadius = 5
//        contentView.layer.shadowOpacity = 0.3
//        contentView.layer.shadowOffset = .zero
//        
//        view.addSubview(contentView)
//        
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(DetailedViewController.handlePan(pan:)))
//        contentView.addGestureRecognizer(pan)
//
//    }
//    
//    @IBAction func handleCloseButtonTapped(_ sender: UIButton) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func panelTransitionWillAnimateTransition(transition: PanelTransition, presenting: Bool, isForeground: Bool) {
//        if presenting {
//            contentView.frame.origin.y = view.bounds.height
//            detailButton.alpha = 0
//            
//            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
//                [self]
//                self.contentView.frame.origin.y = self.kContentViewTopOffset
//                self.detailButton.alpha = 1
//            }, completion: nil)
//        }
//        else {
//            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
//                [self]
//                self.contentView.frame.origin.y = self.view.bounds.height
//                self.detailButton.alpha = 0
//            }, completion: nil)
//        }
//    }
//    
//    
//    func handlePan(pan: UIPanGestureRecognizer) {
//        switch pan.state {
//        case .began:
//            fallthrough
//        case .changed:
//            contentView.frame.origin.y += pan.translation(in: view).y
//            pan.setTranslation(.zero, in: view)
//            
//            let progress = (contentView.frame.origin.y - kContentViewTopOffset) / (view.bounds.height - kContentViewTopOffset - kContentViewBottomOffset)
//            detailView.transitionProgress = progress
//            
//        case .ended:
//            fallthrough
//        case .cancelled:
//            let progress = (contentView.frame.origin.y - kContentViewTopOffset) / (view.bounds.height - kContentViewTopOffset - kContentViewBottomOffset)
//            if progress > 0.5 {
//                let duration = TimeInterval(1-progress) * kContentViewAnimationDuration
//                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
//                    [self]
//                    
//                    self.detailView.transitionProgress = 1
//                    self.contentView.frame.origin.y = self.view.bounds.height - self.kContentViewBottomOffset
//                    
//                }, completion: nil)
//            }
//            else {
//                let duration = TimeInterval(progress) * kContentViewAnimationDuration
//                UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
//                    [self]
//                    
//                    self.detailView.transitionProgress = 0
//                    self.contentView.frame.origin.y = self.kContentViewTopOffset
//                    
//                }, completion: nil)
//            }
//            
//        default:
//            ()
//        }
//    }
//}
//
//extension DetailedViewController: PanelTransitionViewController {
//    func panelTransitionDetailViewForTransition(transition: PanelTransition) -> DetailedView! {
//        return detailView
//    }
//}
