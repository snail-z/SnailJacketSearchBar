//
//  LenPopupNextViewController.swift
//  Lento
//
//  Created by zhang on 2022/12/30.
//

import UIKit
import AmassingUI
import LentoBaseKit

class LenPopupNextViewController: LentoBaseViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .custom;
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var dissButton: MAButton!
    var visorTab: UIView!
    
    var isInteractive = false
    let interactiveCoordinator = UIPercentDrivenInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .random(.gentle)

        visorTab = UIView()
//        let pan = MKScreenEdgePanGestureRecognizer(target: self, action: #selector(didPan))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        pan.delegate = self
//        pan.edges = .all
        visorTab.addGestureRecognizer(pan)
        view.addSubview(visorTab)
        visorTab.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dissButton = MAButton()
        dissButton.imagePlacement = .left
        dissButton.imageAndTitleSpacing = 10
        dissButton.imageView.image = UIImage(named: "hotfill")
        dissButton.imageFixedSize = CGSize(width: 16, height: 16)
        dissButton.titleLabel.textColor = .white
        dissButton.contentHorizontalAlignment = .center
        dissButton.backgroundColor = .brown
        dissButton.titleLabel.text = "点我消失"
        view.addSubview(dissButton)
        
        dissButton.snp.makeConstraints { make in
            make.top.equalTo(200)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        dissButton.addTapGesture { [weak self] tap in
            self?.transitioningDelegate = self
            self?.dismiss(animated: true)
        }
    }
    
    @objc func didPan(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: view).y
        let distance = translation / view.bounds.height

        let speed = pan.velocity(in: view)
        print("飞机===> speed is: \(speed)")

        self.interactiveCoordinator.completionSpeed = 1.1 - distance

        switch (pan.state) {
        case .began:
            print("===> began speed is: \(speed)")
            self.isInteractive = true
            self.transitioningDelegate = self
            self.dismiss(animated: true)
        case .changed:
            self.interactiveCoordinator.update(distance)
        default:
            print("===> end speed is: \(speed)")
            self.isInteractive = false

            if speed.y < 0 {
                if abs(speed.y) > 100 {
                    self.interactiveCoordinator.cancel()
                } else {
                    if distance < 0.5 {
                        self.interactiveCoordinator.cancel()
                    } else {
                        self.interactiveCoordinator.finish()
                    }
                }
            } else {/// 意图向下
                if abs(speed.y) > 100 {
                    self.interactiveCoordinator.finish()
                } else {
                    if distance < 0.5 {
                        self.interactiveCoordinator.cancel()
                    } else {
                        self.interactiveCoordinator.finish()
                    }
                }
            }
            
            
//            MACardFlowView
//            PKCardFlowView
            
//            if distance < 0.5 {
//                self.interactiveCoordinator.cancel()
//            } else {
//                self.interactiveCoordinator.finish()
//            }
            
//            AMCardFlowView
//            AUCardFlowView
//            PKCardFlowView
//            MkUIPanGestureRecognizer
//            MKCardFlowView
            
        }
    }
    
    deinit {
        print("✈️✈️LenPopupNextViewController-dello")
    }
        
}

extension LenPopupNextViewController {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture:UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let velocity = gesture.velocity(in: view)
        print("velocity======x======> \(velocity)")
//        if velocity.x < 0 {
//            if abs(velocity.x) > abs(velocity.y) {
//                print("=====x======> 从右往左边滑动")
//                return true
//            } else {
//                print("=====x======> 从左边wang右边滑动")
//            }
//        } else {
////            print("velocity=======BBBBB")
//        }
        
        if velocity.y > 0 {
            if abs(velocity.y) > abs(velocity.x) {
                print("=====x======> 从上往下边滑动")
                return true
            }
        }
        
        if velocity.y < 0 {
            
        }
        
        return false
    }
}


extension LenPopupNextViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let pop = MAPopupAnimation(type: .none)
        return pop
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let pop = MAPopupAnimation.init(type: .none)
        return pop
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DragTransitionPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactiveCoordinator : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.isInteractive ? self.interactiveCoordinator : nil
    }
}
