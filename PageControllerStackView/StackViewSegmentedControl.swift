//
//  StackViewSegmentedControl.swift
//  PageControlStackView
//
//  Created by Jeff Mew on 2017-11-09.
//  Copyright © 2017 Jeff Mew. All rights reserved.
//

import UIKit

class StackViewSegmentControl : UIView {

    init(segments: UInt) {
        super.init(frame: .zero)
        
        self.addSubview(rootStackView)
        rootStackView.addArrangedSubview(activeDot)
        for _ in 2...segments {
            rootStackView.addArrangedSubview(inactiveDot())
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        let constraints : [NSLayoutConstraint] = [
            rootStackView.topAnchor.constraint(equalTo: self.topAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            ]
        
        let trailingConstraint = rootStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        trailingConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate(constraints)
        NSLayoutConstraint.activate([trailingConstraint])
        
        super.updateConstraints()
    }
    
    //MARK: Accessors
    
    private lazy var rootStackView: UIStackView = {
        let rootstackview = UIStackView()
        rootstackview.translatesAutoresizingMaskIntoConstraints = false
        rootstackview.axis = .horizontal
        rootstackview.spacing = 10.0
        rootstackview.distribution = .equalSpacing
        rootstackview.layoutMargins = .zero
        rootstackview.heightAnchor.constraint(equalToConstant: 12)
        return rootstackview
    }()
    
    private lazy var activeDot: UIImageView = {
        let activedot = UIImageView()
        activedot.image = UIImage(named: "Dot")
        activedot.tintColor = UIColor.darkGray
        return activedot
    }()
    
    private func inactiveDot() -> UIImageView {
        let inactivedot = UIImageView()
        inactivedot.image = UIImage(named: "Dot")
        inactivedot.tintColor = UIColor.white
        return inactivedot
    }
    
    //MARK: Helpers
    
    public func moveDotForward() {
        if let index = rootStackView.arrangedSubviews.index(of: activeDot) {
            rootStackView.insertArrangedSubview(activeDot, at: index + 1)
        }
    }
    
    public func moveDotBackward() {
        if let index = rootStackView.arrangedSubviews.index(of: activeDot) {
            rootStackView.insertArrangedSubview(activeDot, at: index - 1)
        }
    }
    
    public func moveDotToEnd() {
        rootStackView.insertArrangedSubview(activeDot, at: rootStackView.arrangedSubviews.count - 1)
    }
}
