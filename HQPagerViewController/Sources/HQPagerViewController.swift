//
//  HQPagerViewController.swift
//  HQPagerViewController
//
//  Created by robert pham on 11/10/16.
//  Copyright © 2016 quangpc. All rights reserved.
//

import UIKit

public protocol HQPagerViewControllerDataSource {
    func menuViewItemOf(inPager pagerViewController: HQPagerViewController)-> HQPagerMenuViewItemProvider
}

open class HQPagerViewController: UIViewController {
    
    @IBOutlet public weak var menuView: HQPagerMenuView!
    
    @IBOutlet public weak var containerView: UIView!
    
    public var pageViewController: UIPageViewController!
    
    public var viewControllers: [UIViewController]? {
        didSet {
            setupViewControllers()
        }
    }
    public var nextIndex: Int = 0
    public var selectedIndex: Int = 0

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupMenuView()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Public functions
    public func setSelectedIndex(index: Int, animated: Bool) {
        menuView.setSelectedIndex(index: index, animated: animated)
        selectViewController(atIndex: index, animated: animated)
    }

    private func setupMenuView() {
        menuView.selectedIndex = selectedIndex
        menuView.dataSource = self
        menuView.delegate = self
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.frame = containerView.bounds
        pageViewController.dataSource = self
        pageViewController.delegate = self
        addChildViewController(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        
        // add constrains
        pageViewController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        pageViewController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        self.view.layoutIfNeeded()
    }
    
    fileprivate func indexOfViewController(viewController: UIViewController)-> Int? {
        if let viewControllers = viewControllers {
            for i in 0..<viewControllers.count {
                let vc = viewControllers[i]
                if vc == viewController {
                    return i
                }
            }
        }
        return nil
    }
    
    fileprivate func setupViewControllers() {
        if let viewControllers = viewControllers {
            menuView.reloadData()
            let viewController = viewControllers[selectedIndex]
            pageViewController.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
            viewControllers.forEach { if !($0 is HQPagerViewControllerDataSource) { fatalError("Every child view controller must conform to  HQPagerViewControllerDataSource") }}
        }
    }
    
    fileprivate func selectViewController(atIndex index: Int, animated: Bool) {
        if let viewControllers = viewControllers {
            let oldIndex = selectedIndex
            selectedIndex = index
            let direction: UIPageViewControllerNavigationDirection = (oldIndex < selectedIndex) ? .forward : .reverse
            if index >= 0 && index < viewControllers.count {
                let viewController = viewControllers[index]
                pageViewController.setViewControllers([viewController], direction: direction, animated: animated, completion: nil)
            }
        }
    }
}

extension HQPagerViewController: HQPagerMenuViewDataSource {
    public func numberOfItems(inPagerMenu menuView: HQPagerMenuView) -> Int {
        if let viewControllers = viewControllers {
            return viewControllers.count
        }
        return 0
    }
    public func pagerMenuView(_ menuView: HQPagerMenuView, itemAt index: Int) -> HQPagerMenuViewItemProvider? {
        if let viewControllers = viewControllers {
            if let viewController = viewControllers[index] as? HQPagerViewControllerDataSource {
                return viewController.menuViewItemOf(inPager: self)
            }
        }
        return nil
    }
}

extension HQPagerViewController: HQPagerMenuViewDelegate {
    public func menuView(_ menuView: HQPagerMenuView, didChangeToIndex index: Int) {
        selectViewController(atIndex: index, animated: true)
    }
}

extension HQPagerViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = indexOfViewController(viewController: viewController) {
            if index > 0 {
                return viewControllers?[index-1]
            }
        }
        return nil
    }
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = indexOfViewController(viewController: viewController) {
            if let viewControllers = viewControllers, index < viewControllers.count-1 {
                return viewControllers[index+1]
            }
        }
        return nil
    }
}

extension HQPagerViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first, let index = indexOfViewController(viewController: vc) {
            self.nextIndex = index
        }
    }
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let vc = previousViewControllers.first, let previousIndex = indexOfViewController(viewController: vc) {
                if self.nextIndex != previousIndex {
                    if let currentVc = pageViewController.viewControllers?.first {
                        if let index = indexOfViewController(viewController: currentVc) {
                            self.selectedIndex = index
                            menuView.setSelectedIndex(index: index, animated: true)
                        }
                    }
                }
            }
        }
        self.nextIndex = self.selectedIndex
    }
}
