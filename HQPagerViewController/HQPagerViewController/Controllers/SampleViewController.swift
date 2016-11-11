//
//  SampleViewController.swift
//  HQPagerViewController
//
//  Created by quangpc on 11/11/16.
//  Copyright © 2016 quangpc. All rights reserved.
//

import UIKit

let titles = ["Trending", "Search", "Recents", "Me"]
let colors = [UIColor.hexColor(hex: "82b840"), UIColor.hexColor(hex: "26abfc"), UIColor.hexColor(hex: "ff9c29"), UIColor.hexColor(hex: "f59c94")]
let normalIcons = [UIImage(named: "icon-trend"), UIImage(named: "icon-react"), UIImage(named: "icon-favorite"), UIImage(named: "icon-me")]
let highlightedIcons = [UIImage(named: "icon-trend-selected"), UIImage(named: "icon-react-selected"), UIImage(named: "icon-favorite-selected"), UIImage(named: "icon-me-selected")]

class SampleViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = "ViewController #\(index)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SampleViewController: HQPagerViewControllerDataSource {
    func menuViewItemOf(inPager pagerViewController: HQPagerViewController) -> HQPagerMenuViewItemProvider {
        let item = HQPagerMenuViewItemProvider(title: titles[index], normalImage: normalIcons[index], selectedImage: highlightedIcons[index], selectedBackgroundColor: colors[index])
        return item
    }
}
