//
//  EMPartialModalViewController.swift
//  EMPartialModalViewController
//
//  Created by Emad A. on 25/01/2015.
//  Copyright (c) 2015 Emad A. All rights reserved.
//

import UIKit

class EMPartialModalViewController: UIViewController {

    // MARK: - Constants

    private let snapshotScale: CGFloat = 0.94

    // MARK: - Public Properties

    // The max height of content navigation view controller
    var contentViewMaxHeight: CGFloat = 402 {
        didSet {
            if contentViewController != nil {
                var frame: CGRect = contentViewController!.view.frame
                frame.size.height = contentViewMaxHeight
                frame.origin.y = CGRectGetMaxY(view.bounds) - frame.height

                contentViewController!.view.frame = frame
            }
        }
    }

    // MARK: - Private Properties

    // The height of content navigation view controller
    private var contentViewHeight: CGFloat = 0

    // A snapshot of man screen with status bar
    private var snapshotView: UIView = UIScreen.mainScreen().snapshotViewAfterScreenUpdates(false)

    // An overlay view, as button to dismiss the modal view controller on being touched
    private let overlayView: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton

    // A view controller holds the main content of modal
    private var contentViewController: UIViewController?

    // MARK: - Initializers

    convenience init(rootViewController: UIViewController) {
        self.init(rootViewController: rootViewController, contentHeight: rootViewController.view.bounds.height)
    }

    convenience init(rootViewController: UIViewController, contentHeight: CGFloat) {
        self.init()

        contentViewHeight = contentHeight

        contentViewController = rootViewController
        if contentViewController != nil {
            view.addSubview(contentViewController!.view)
            addChildViewController(contentViewController!)
        }
    }

    // MARK: - Overriden Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting view controler properties to have customized presentation transition
        transitioningDelegate = self
        modalPresentationCapturesStatusBarAppearance = true
        modalPresentationStyle = UIModalPresentationStyle.Custom

        // The view should have balck background color.
        view.opaque = true
        view.backgroundColor = UIColor.blackColor()

        // Initializing overlay
        overlayView.frame = view.bounds
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        overlayView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        overlayView.addTarget(self, action: Selector("dismissViewController"), forControlEvents: UIControlEvents.TouchUpInside)

        view.addSubview(overlayView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if contentViewController != nil {
            contentViewHeight = min(contentViewHeight, self.contentViewMaxHeight)
            var frame = CGRectZero
            frame.size = CGSizeMake(view.bounds.width, contentViewHeight)
            frame.origin = CGPointMake(CGRectGetMinX(view.bounds), CGRectGetMaxY(view.bounds) - frame.height)
            contentViewController!.view.frame = frame
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Public Methods

    func dismissViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension EMPartialModalViewController: UIViewControllerTransitioningDelegate {

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension EMPartialModalViewController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.42
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController: UIViewController? = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController: UIViewController? = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let animationDuration: NSTimeInterval = transitionDuration(transitionContext)
        let containerView: UIView = transitionContext.containerView()

        fromViewController?.viewWillDisappear(transitionContext.isAnimated())
        toViewController?.viewWillAppear(transitionContext.isAnimated())

        // To present the view controller
        if let viewController: EMPartialModalViewController = toViewController as? EMPartialModalViewController {
            if viewController.contentViewController == nil {
                return;
            }

            // Setting the srart point of overlay alpha animation
            viewController.overlayView.alpha = 0;

            // Inserting the snapshot of the window root view controller at the back all views of modal view controller
            // The snapshot is going to be scaled down
            let snapshot: UIView = viewController.snapshotView
            viewController.view.insertSubview(snapshot, atIndex: 0)

            // Frame for snapshot to scale it down according to scales
            // This way the scale anchore would be top middle.
            var frame: CGRect = snapshot.superview!.bounds
            frame.origin.x += snapshot.superview!.bounds.width * (1 - snapshotScale) / 2
            frame.origin.y = frame.origin.x
            frame.size.width *= snapshotScale
            frame.size.height *= snapshotScale

            // Putting the modal view content at the bottom of the view
            let view = viewController.contentViewController!.view
            view.transform = CGAffineTransformMakeTranslation(0, view.bounds.height)

            // Adding the modal view controller into view
            containerView.addSubview(viewController.view)

            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
            
            // Starting animation
            UIView.animateWithDuration(
                animationDuration,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity:  1,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: { () -> Void in
                    viewController.overlayView.alpha = 1
                    view.transform = CGAffineTransformMakeTranslation(0, 0)
                    snapshot.frame = frame
                },
                completion: { (Bool) -> Void in
                    transitionContext.completeTransition(true)
                    viewController.viewDidAppear(transitionContext.isAnimated())
                    fromViewController?.viewDidDisappear(transitionContext.isAnimated())
                })
        }

        // To dismiss the view controller
        else if let viewController: EMPartialModalViewController = fromViewController as? EMPartialModalViewController {
            if viewController.contentViewController == nil {
                return;
            }

            // Getting the view of the content view controller
            let view: UIView = viewController.contentViewController!.view

            // Start animation
            UIView.animateWithDuration(
                animationDuration,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity:  1,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: { () -> Void in
                    viewController.overlayView.alpha = 0;
                    view.transform = CGAffineTransformMakeTranslation(0, view.bounds.height)
                    viewController.snapshotView.frame = viewController.snapshotView.superview!.bounds
                },
                completion: { (Bool) -> Void in
                    UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
                    transitionContext.completeTransition(true)
                    viewController.viewDidAppear(transitionContext.isAnimated())
                    fromViewController?.viewDidDisappear(transitionContext.isAnimated())
            })
        }
    }
}