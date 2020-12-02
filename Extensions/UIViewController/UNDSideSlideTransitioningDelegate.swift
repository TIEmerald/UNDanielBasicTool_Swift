//
//  UNDSideSlideTransitioningDelegate.swift
//  test_project
//
//  Created by UNDaniel on 2020/11/27.
//

import UIKit

class UNDSideSlideTransitioningConfigModel: NSObject {
    
    enum MaskEffect {
        case maskDark
        case blurDark
    }
    
    enum PresentPosition {
        case bottom
        case center
    }
    
    var presentDuration: TimeInterval = 0.4
    var dismissDuration: TimeInterval = 0.4
    var maskEffect: MaskEffect
    var presentPosition: PresentPosition
    var shouldDismissWhileClickBackground: Bool
    var shouldShrinkPresentingViewController: Bool
    var couldDragInUpDirection: Bool
    var couldDragPresentedView: Bool
    fileprivate var preferredSize = CGSize.zero
    
    init(maskEffect: MaskEffect = .maskDark, presentPosition: PresentPosition = .bottom, shouldDismissWhileClickBackground: Bool = false, shouldShrinkPresentingViewController: Bool = false, couldDragInUpDirection: Bool = false, couldDragPresentedView: Bool = false) {
        self.maskEffect = maskEffect
        self.presentPosition = presentPosition
        self.shouldDismissWhileClickBackground = shouldDismissWhileClickBackground
        self.shouldShrinkPresentingViewController = shouldShrinkPresentingViewController
        self.couldDragInUpDirection = couldDragInUpDirection
        self.couldDragPresentedView = couldDragPresentedView
    }
    
    fileprivate func preferredOriginPoint(from presentingView: UIView) -> CGPoint {
        var presentingX = presentingView.frame.size.width - self.preferredSize.width
        var presentingY = presentingView.frame.size.height - self.preferredSize.height
        switch presentPosition {
        case .center:
            presentingX /= 2
            presentingY /= 2
        case .bottom:
            fallthrough
        default:
            presentingX /= 2
        }
        return CGPoint(x: presentingX, y: presentingY)
    }
}

extension UNDSideSlideTransitioningConfigModel: UIViewControllerTransitioningDelegate {
    
    // Mark: - Delegates
    // Mark: - UIViewControllerTransitioningDelegate
    internal func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return UNDSideSlidePresentTransitionAnimator(timeInterval: self.presentDuration, and: self)
    }
    
    internal func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return UNDSideSlideDismissTransitionAnimator(timeInterval: self.dismissDuration, and: self)
    }
    
    internal func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return UNDSideSlidePresentationController(presentedViewController: presented
                                                  , presentingViewController: presenting
                                                  , and: self)
    }
}


extension UIViewController {
    
    private static let relatedConfigAssociation = ObjectAssociation<UNDSideSlideTransitioningConfigModel>()
    
    var relatedConfig: UNDSideSlideTransitioningConfigModel! {
        get { return UIViewController.relatedConfigAssociation[self] }
        set { UIViewController.relatedConfigAssociation[self] = newValue }
    }
    
    // Mark: - General Methods
    func sideSlide_show(_ viewController: UIViewController, with config: UNDSideSlideTransitioningConfigModel = UNDSideSlideTransitioningConfigModel(), completion: (() -> Void)? = nil) {
        if viewController.preferredContentSize != CGSize.zero {
            config.preferredSize = viewController.preferredContentSize
        } else {
            config.preferredSize = CGSize(width: self.view.bounds.size.width
                                          , height: self.view.bounds.size.height / 2) // By Default the size is half height of presenting view controller
        }
        self.relatedConfig = config
        viewController.modalPresentationStyle = .custom
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.transitioningDelegate = self.relatedConfig
        self.present(viewController, animated: true, completion: completion)
    }
}

fileprivate class UNDSideSlideBaseTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var timeInterval: TimeInterval
    var config: UNDSideSlideTransitioningConfigModel
    
    // Mark: - Init
    init(timeInterval: TimeInterval, and config: UNDSideSlideTransitioningConfigModel) {
        self.timeInterval = timeInterval
        self.config = config
    }
    
    // Mark: - Protocols
    // Mark: - UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.timeInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError("animateTransition(using transitionContext: UIViewControllerContextTransitioning) has not been implemented")
    }
}

fileprivate class UNDSideSlidePresentTransitionAnimator: UNDSideSlideBaseTransitionAnimator {
    // Mark: - Protocols
    // Mark: - UIViewControllerAnimatedTransitioning
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        let presentingOrigin = self.config.preferredOriginPoint(from: transitionContext.containerView)
        let preferredSize = self.config.preferredSize
        
        var originalToViewFrame: CGRect {
            return CGRect(origin: CGPoint(x: presentingOrigin.x
                                          , y: transitionContext.containerView.frame.size.height)
                          , size: preferredSize)
        }
        
        var presentingToViewFrame: CGRect {
            return CGRect(origin: presentingOrigin
                          , size: preferredSize)
        }
        
        transitionContext.containerView.addSubview(toView)
        toView.alpha = 0
        toView.frame = originalToViewFrame
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            toView.alpha = 1
            toView.frame = presentingToViewFrame
        } completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
}

fileprivate class UNDSideSlideDismissTransitionAnimator: UNDSideSlideBaseTransitionAnimator {
    // Mark: - Protocols
    // Mark: - UIViewControllerAnimatedTransitioning
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext)) {
            fromView.alpha = 0
            fromView.frame = CGRect(x: fromView.frame.origin.x
                                    , y: transitionContext.containerView.frame.size.height
                                    , width: fromView.frame.size.width
                                    , height: fromView.frame.size.height)
        } completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
}

fileprivate class UNDSideSlidePresentationController: UIPresentationController {
    
    var configureModel: UNDSideSlideTransitioningConfigModel
    var dimmingView: UIView!
    var panGestureRecognizer: UIPanGestureRecognizer?
    var dismissTapGestureRecognizer: UITapGestureRecognizer?
    
    private var shouldComplete = false
    
    // Mark: - Init
    init(presentedViewController: UIViewController, presentingViewController: UIViewController?, and configureModel: UNDSideSlideTransitioningConfigModel) {
        self.configureModel = configureModel
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.dimmingView = self.setUpDimmingView(with: self.configureModel.maskEffect)
        if self.configureModel.couldDragPresentedView {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.onDrag(_:)))
            presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
        }
        if self.configureModel.shouldDismissWhileClickBackground {
            let dismissTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onTapBackground(_:)))
            self.dimmingView.addGestureRecognizer(dismissTapGestureRecognizer)
        }
    }
    
    // Mark: Support Methods
    func setUpDimmingView(with maskEffect:UNDSideSlideTransitioningConfigModel.MaskEffect) -> UIView {
        var tempFrame = CGRect.zero
        if let unWrappedContainerView = self.containerView {
            tempFrame = CGRect(x: 0, y: 0, width: unWrappedContainerView.bounds.width, height: unWrappedContainerView.bounds.height)
        }
        switch maskEffect {
        case .blurDark:
            let blurEffect = UIBlurEffect.init(style: .dark)
            let blurEffectView = UIVisualEffectView.init(effect: blurEffect)
            blurEffectView.frame = tempFrame
            
            let vibrancyEffect = UIVibrancyEffect.init(blurEffect: blurEffect)
            let vibrancyEffectView = UIVisualEffectView.init(effect: vibrancyEffect)
            vibrancyEffectView.frame = tempFrame
            blurEffectView.addSubview(vibrancyEffectView)
            return blurEffectView
        case .maskDark:
            fallthrough
        default:
            let returnView = UIView.init(frame: tempFrame)
            returnView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            return returnView
        }
    }
    
    // Mark: - Super
    // Mark: - UIPresentationController
    override var frameOfPresentedViewInContainerView: CGRect {
        if let unWrappedContainerView = self.containerView {
            return CGRect(origin: self.configureModel.preferredOriginPoint(from: unWrappedContainerView)
                          , size: self.configureModel.preferredSize)
        } else {
            return CGRect.zero
        }
    }
    
    override func presentationTransitionWillBegin() {
        self.dimmingView.alpha = 0;
        if let unWrappedContainerView = self.containerView {
            self.dimmingView.frame = CGRect(x: 0, y: 0, width: unWrappedContainerView.bounds.width, height: unWrappedContainerView.bounds.height)
        }
        self.containerView?.addSubview(self.dimmingView)
        self.dimmingView.addSubview(self.presentedViewController.view)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (_) in
            self.dimmingView.alpha = 1
            if self.configureModel.shouldShrinkPresentingViewController {
                self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView.alpha = 0
            self.presentingViewController.view.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.dimmingView.removeFromSuperview()
            self.dimmingView = nil
        }
    }
    
    // Mark: - Gesture Recognizer
    @objc func onDrag(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        switch gestureRecognizer.state {
        case .began: break
        case .changed:
            if self.configureModel.couldDragInUpDirection || translation.y > 0 {
                self.presentedView?.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
            if let unWrappedContainerView = self.containerView {
                let threshold = CGFloat(0.1)
                var dragPercent = translation.y / unWrappedContainerView.frame.size.height
                dragPercent = max(dragPercent, 0.0)
                dragPercent = min(dragPercent, 1.0)
                self.shouldComplete = dragPercent > threshold
            }
        case .ended:
            if self.shouldComplete {
                self.dismissPresentedViewController()
            } else {
                self.resetPreserntViewBackToIdle()
            }
        case .cancelled:
            self.resetPreserntViewBackToIdle()
        default: break
        }
    }
    
    @objc func onTapBackground(_ gestureRecognizer: UITapGestureRecognizer) {
        self.dismissPresentedViewController()
    }
    
    // Mark: - Support Methods
    func dismissPresentedViewController() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    func resetPreserntViewBackToIdle() {
        UIView.animate(withDuration: 0.8
                       , delay: 0
                       , usingSpringWithDamping: 1
                       , initialSpringVelocity: 1
                       , options: .curveEaseInOut) {
            self.presentedView?.transform = CGAffineTransform.identity
        } completion: { (_) in }

    }
}

public final class ObjectAssociation<T: AnyObject> {

    private let policy: objc_AssociationPolicy

    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {

        self.policy = policy
    }

    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {

        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}
