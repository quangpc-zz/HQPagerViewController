//
//  HQPagerViewController.swift
//  HQPagerViewController
//
//  Created by robert pham on 11/10/16.
//  Copyright © 2016 quangpc. All rights reserved.
//

import UIKit

public protocol HQPagerViewControllerDataSource {
    
}

open class HQPagerViewController: UIViewController {
    
    @IBOutlet public weak var menuView: HQPagerMenuView!
    
    @IBOutlet public weak var containerView: UIView!
    
//    public var viewControllers: []

    override open func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
