//
//  ProgressNavigationController.swift
//  NavigationProgress
//
//  Created by Sebastian Osiński on 01/05/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

protocol FlowProgressReporting {
    var flowProgress: Float { get }
}

final class ProgressNavigationController: UINavigationController {
    private let progressView = UIProgressView(progressViewStyle: .bar)
    
    // Property which is used to circumvent iOS bug: https://openradar.appspot.com/38135706
    private var isConsecutiveAnimatedTransition = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

        setupProgressView()
    }
    
    private func setupProgressView() {
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.0)
        ])
    }
}

extension ProgressNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let flowProgress = (viewController as? FlowProgressReporting)?.flowProgress
        let progressViewTargetAlpha: CGFloat = flowProgress == nil ? 0.0 : 1.0
        
        let actions = { [progressView] in
            progressView.alpha = progressViewTargetAlpha
            
            if let flowProgress = flowProgress {
                progressView.setProgress(flowProgress, animated: animated)
            }
        }
        
        guard animated else {
            return actions()
        }
        
        // Fix for iOS bug: https://openradar.appspot.com/38135706
        guard isConsecutiveAnimatedTransition else {
            UIView.animate(withDuration: transitionCoordinator?.transitionDuration ?? 0.0, animations: actions)
            isConsecutiveAnimatedTransition = true
            
            return
        }
        
        transitionCoordinator?.animate(
            alongsideTransition: { _ in
                actions()
            },
            completion: { [progressView] context in
                guard context.isCancelled else { return }
                
                let previousFlowProgress = (self.topViewController as? FlowProgressReporting)?.flowProgress
                let previousProgressViewTargetAlpha: CGFloat = previousFlowProgress == nil ? 0.0 : 1.0
                
                UIView.animate(withDuration: context.transitionDuration) {
                    progressView.alpha = previousProgressViewTargetAlpha
                }
                
                if let previousFlowProgress = previousFlowProgress {
                    progressView.setProgress(previousFlowProgress, animated: true)
                }
            }
        )
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Initial case, first push
        // It's also triggered when we pop to first view controller, but it does not bother us
        guard viewControllers.count == 1 else { return }

        let flowProgress = (viewController as? FlowProgressReporting)?.flowProgress
        let progressViewTargetAlpha: CGFloat = flowProgress == nil ? 0.0 : 1.0
        
        progressView.alpha = progressViewTargetAlpha
        // Reset progress to 0 if first view controller is not FlowProgressReporting
        progressView.progress = flowProgress ?? 0.0
    }
}
