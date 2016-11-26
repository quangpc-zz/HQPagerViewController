//
//  HQPagerMenuView.swift
//  HQPagerViewController
//
//  Created by robert pham on 11/10/16.
//  Copyright © 2016 quangpc. All rights reserved.
//

import UIKit

private let switchAnimationDuration: TimeInterval = 0.3
private let highlighterAnimationDuration: TimeInterval = switchAnimationDuration / 2

public struct HQPagerMenuViewItemProvider {
    public var title: String
    public var normalImage: UIImage?
    public var selectedImage: UIImage?
    public var selectedBackgroundColor: UIColor?
    
    public init(title: String, normalImage: UIImage?, selectedImage: UIImage?, selectedBackgroundColor: UIColor?) {
        self.title = title
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.selectedBackgroundColor = selectedBackgroundColor
    }
}

public protocol HQPagerMenuViewDataSource: class {
    func numberOfItems(inPagerMenu menuView: HQPagerMenuView)-> Int
    func pagerMenuView(_ menuView: HQPagerMenuView, itemAt index: Int)-> HQPagerMenuViewItemProvider?
}

public protocol HQPagerMenuViewDelegate: class {
    func menuView(_ menuView: HQPagerMenuView, didChangeToIndex index: Int)
}

open class HQPagerMenuView: UIView {

    open var titleFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            for label in labels {
                label.font = titleFont
            }
            updateHighlightViewPosition()
        }
    }
    
    open var titleTextColor: UIColor = .white {
        didSet {
            for label in labels {
                label.textColor = titleTextColor
            }
        }
    }
    
    public var selectedIndex: Int = 0
    
    fileprivate let stackView = UIStackView()
    
    fileprivate var highlightView = HQRoundCornerView(frame: CGRect.zero)
    
    fileprivate var buttons: [UIButton] = []
    
    fileprivate var labels: [UILabel] = []
    
    open weak var dataSource: HQPagerMenuViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    open weak var delegate: HQPagerMenuViewDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(highlightView)
        
        stackView.frame = self.bounds
        stackView.backgroundColor = UIColor.clear
        addSubview(stackView)
        stackView.distribution = .fillEqually
        self.layoutIfNeeded()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
        stackView.layoutIfNeeded()
        if selectedIndex >= 0 {
            updateHighlightViewPosition()
        }
    }
    
    public func reloadData() {
        guard let dataSource = dataSource else {
            return
        }
        buttons.removeAll()
        labels.removeAll()
        for subView in stackView.subviews {
            subView.removeFromSuperview()
        }
        let numberOfItems = dataSource.numberOfItems(inPagerMenu: self)
        for i in 0..<numberOfItems {
            let button = createButton(atIndex: i)
            buttons.append(button)
            stackView.addArrangedSubview(button)
            
            let label = createLabel(atIndex: i)
            labels.append(label)
            stackView.addArrangedSubview(label)
        }
        stackView.layoutIfNeeded()
        updateHighlightViewPosition()
    }
    
    fileprivate func updateHighlightViewPosition() {
        showSelectedLabel()
        moveHighlightView(toIndex: selectedIndex)
    }
    
    public func setSelectedIndex(index: Int, animated: Bool) {
        let oldIndex = selectedIndex
        selectedIndex = index
        self.showSelectedLabel()
        if animated {
            if index != oldIndex {
                transitionAnimated(to: index)
            }
        } else {
            moveHighlightView(toIndex: index)
        }
    }
    
    fileprivate func transitionAnimated(to toIndex: Int) {
        let animation = {
            self.moveHighlightView(toIndex: toIndex)
        }
        
        UIView.animate(
            withDuration: switchAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 3,
            options: [],
            animations: animation,
            completion: nil
        )
    }
    
    fileprivate func showSelectedLabel() {
        for i in 0..<buttons.count {
            let button = buttons[i]
            let label = labels[i]
            
            label.isHidden = (i != selectedIndex)
            label.alpha = (i != selectedIndex) ? 0 : 1
            button.isSelected = (i == selectedIndex)
        }
        self.stackView.layoutIfNeeded()
    }
    
    fileprivate func moveHighlightView(toIndex index:Int) {
        guard let dataSource = dataSource else {
            return
        }
        let numberOfItems = dataSource.numberOfItems(inPagerMenu: self)
        if index > labels.count-1 || index < 0 {
            return
        }
        let toLabel = labels[index]
        let toButton = buttons[index]
        
        let labelFrame = convert(toLabel.frame, to: self)
        let buttonFrame = convert(toButton.frame, to: self)
        
        var targetFrame = CGRect(x: buttonFrame.minX, y: 0, width: labelFrame.maxX - buttonFrame.minX, height: bounds.size.height)
        let delta = bounds.size.height/2
        if index == 0 {
            targetFrame = CGRect(x: -delta, y: 0, width: labelFrame.maxX + delta, height: bounds.size.height)
        }
        if index == numberOfItems-1 {
            targetFrame = CGRect(x: buttonFrame.minX, y: 0, width: bounds.size.width - buttonFrame.minX + delta, height: bounds.size.height)
        }
        highlightView.frame = targetFrame
        if let item = dataSource.pagerMenuView(self, itemAt: index) {
            highlightView.backgroundColor = item.selectedBackgroundColor
        }
    }
    
    private func createLabel(atIndex index:Int)-> UILabel {
        guard let dataSource = dataSource, let item = dataSource.pagerMenuView(self, itemAt: index) else {
            return UILabel(frame:
            .zero)
        }
        
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = .left
        label.font = titleFont
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        label.textColor = titleTextColor
        label.text = item.title
        return label
    }
    
    private func createButton(atIndex index: Int)-> UIButton {
        guard let dataSource = dataSource, let item = dataSource.pagerMenuView(self, itemAt: index) else {
            return UIButton(frame:
            .zero)
        }
        let button = UIButton()
        button.tag = index
        button.setImage(item.normalImage, for: .normal)
        button.setImage(item.selectedImage, for: .selected)
        button.addTarget(self, action: #selector(HQPagerMenuView.buttonPressed(button:)), for: .touchUpInside)
        return button
    }
    
    @objc fileprivate func buttonPressed(button: UIButton) {
        let oldIndex = selectedIndex
        let newIndex = button.tag
        setSelectedIndex(index: newIndex, animated: true)
        if oldIndex != newIndex {
            delegate?.menuView(self, didChangeToIndex: newIndex)
        }
    }
}

open class HQRoundCornerView: UIView {
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = bounds.size.height/2
    }
}
