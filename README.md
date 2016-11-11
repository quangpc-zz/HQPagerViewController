# HQPagerViewController

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
Check sample project to see how it works.

#### Connect outlets and add layout constrains
We strongly recommend to use IB to set up our page controller views.

Drag into the storyboard a UIViewController and set up its class with your pager controller (HQPagerViewController). Drag a UIView into your view controller view and connect to *containerView* outlet. Drag a UIView into your view controller view and set class to *HQPagerMenuView* then connect to outlet *menuView*

#### Setup data source for child controller
Provide HQPagerMenuViewItemProvider for each child controller

```
extension SampleViewController: HQPagerViewControllerDataSource {
    func menuViewItemOf(inPager pagerViewController: HQPagerViewController) -> HQPagerMenuViewItemProvider {
        let item = HQPagerMenuViewItemProvider(title: titles[index], normalImage: normalIcons[index], selectedImage: highlightedIcons[index], selectedBackgroundColor: colors[index])
        return item
    }
}
```
## Customization

#### Change title Font

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
