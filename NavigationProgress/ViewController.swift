//
//  ViewController.swift
//  NavigationProgress
//
//  Created by Sebastian Osiński on 01/05/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

typealias ViewControllerFactory = () -> (UIViewController)?

class ViewController: UIViewController {
    
    let nextViewController: ViewControllerFactory?
    
    init(nextViewController: ViewControllerFactory? = nil) {
        self.nextViewController = nextViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "No Progress"
        
        view.backgroundColor = .white
        
        let pushButton = UIButton(type: .custom)
        pushButton.setTitle("Push", for: .normal)
        pushButton.setTitleColor(.black, for: .normal)
        pushButton.addTarget(self, action: #selector(pushNextViewController), for: .touchUpInside)
        
        view.addSubview(pushButton)
        pushButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pushButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pushButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func pushNextViewController() {
        guard let nextViewController = nextViewController?() else { return }
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
}

