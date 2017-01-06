# HQPagerViewController

[![Platform](http://img.shields.io/badge/platform-iOS-blue.svg?style=flat)](https://cocoapods.org/?q=HQPagerviewcontroller) [![License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/Yalantis/Segmentio/blob/master/LICENSE) ![Swift 3.x](https://img.shields.io/badge/Swift-3.0-orange.svg) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

This control combines the great menu view with a UIPageviewController that takes care of showing the right page when clicking on the menu view and updating the selection when the UIPageviewController scrolls.

## Screenshots
![Sample screenshot](/sample.gif)

## Installation

### Cocoapods

Install with [Cocoapods](http://cocoapods.org/) by adding the following to your Podfile:

```
platform :ios, '9.0'
pod 'HQPagerViewController', :git=> 'https://github.com/quangpc/HQPagerViewController.git', :branch=> 'master'
```

### Manually
Copy HQPagerViewController.swift & HQPagerMenuView.swift to your project.

## Usage
Basically we just need to provide the list of child view controllers to show and these view controllers should provide the information for conform HQPagerViewControllerDataSource.
Check sample project to see how it works or take a look to the following guide.
We strongly recommend to use IB to set up our page controller views.

## Guide

####1. Create a new ViewController in SB to manage the tabs:
![guide screen step 1](/guide_imgs/guide_define_tabViewController.png)

####2. Define tabs area creating a new UIView, setting its class to HQPagerMenuView, its Bundle to HQPagerViewController and defining constraints as you wish
![guide screen step 2](/guide_imgs/guide_define_menuView.png)

####3. Define container area creating a new UIView and defining its constraints
![guide screen step 3](/guide_imgs/guide_define_containerView.png)

####4. Link tabs and container views outlets to the View Controller
![guide screen step 4](/guide_imgs/guide_linked_outlets.png)

####5. Create tabs controller class.

```
import HQPagerViewController
```

```
// Define tabs titles
let titles = ["Tab1", ...]
// Define tabs background colors
let colors = [UIColor.green, ...]
// Define icons for non selected
let normalIcons = [UIImage(named: "ic_tab_1.png"), ...]
// Define selected tab icon
let highlightedIcons = [UIImage(named: "ic_tab_1.png"), ...]

```

```
class TabVC: HQPagerViewController {
```
```
// build viewcontrollers and set their index
override func viewDidLoad() {
    super.viewDidLoad()
    let vc1 = SampleViewController()
    vc1.index = 0
    // ... 
    self.viewControllers = [vc1, ...]
}
```
####6. Create ViewControllers for tabs and add property 

```
// Add this property to your child view
var index: Int = YOUR_CHILD_VIEW_TAB_POSITION
```

```
// Add this extension in every child view
extension YOUR_CHILD_VIEW_NAME: HQPagerViewControllerDataSource {
    func menuViewItemOf(inPager pagerViewController: HQPagerViewController) -> HQPagerMenuViewItemProvider {

        let item = HQPagerMenuViewItemProvider(title: titles[index], normalImage: normalIcons[index], selectedImage: highlightedIcons[index], selectedBackgroundColor: colors[index])
        return item
    }
}

```

## Customization

#### Change title Font
In your Tabs View Controller:

```
menuView.titleFont = UIFont.boldSystemFont(ofSize: 14)
```

#### Change title text color

```
menuView.titleTextColor = UIColor.black
```

#### Change selected viewcontroller

```
setSelectedIndex(index: 1, animated: false)
```

## Requirements
iOS 9 and above

## Contributions  
...are really welcome. If you have an idea just fork the library change it and if its useful for others and not affecting the functionality of the library for other users I'll insert it

## License
MIT License
