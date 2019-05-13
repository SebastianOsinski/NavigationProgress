//
//  ProgressViewController.swift
//  NavigationProgress
//
//  Created by Sebastian Osiński on 01/05/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

class ProgressViewController: ViewController, FlowProgressReporting {
    let flowProgress: Float
    
    init(flowProgress: Float, nextViewController: ViewControllerFactory? = nil) {
        self.flowProgress = flowProgress
        
        super.init(nextViewController: nextViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flow Progress"

        view.backgroundColor = .white
    }
}
