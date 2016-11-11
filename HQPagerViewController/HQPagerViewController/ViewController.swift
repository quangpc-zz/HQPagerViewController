//
//  ViewController.swift
//  HQPagerViewController
//
//  Created by robert pham on 11/10/16.
//  Copyright © 2016 quangpc. All rights reserved.
//

import UIKit

class ViewController: HQPagerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        setSelectedIndex(index: 1, animated: false)
        
        // build viewcontrollers
        let vc1 = SampleViewController()
        vc1.index = 0
        let vc2 = SampleViewController()
        vc2.index = 1
        let vc3 = SampleViewController()
        vc3.index = 2
        let vc4 = SampleViewController()
        vc4.index = 3
        
        self.viewControllers = [vc1, vc2, vc3, vc4]
        
//        menuView.titleFont = UIFont.boldSystemFont(ofSize: 14)
//        menuView.titleTextColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

