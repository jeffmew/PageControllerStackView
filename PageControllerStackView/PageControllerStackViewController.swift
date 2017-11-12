//
//  PageControlStackViewController.swift
//  PageControlStackViewController
//
//  Created by Jeff Mew on 2017-08-09.
//  Copyright © 2017 Jeff Mew. All rights reserved.
//

import UIKit

class PageControlStackViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        
        super.init(nibName: nil, bundle: nil)
        
        pageController.dataSource = self
        pageController.delegate = self
        
        if let firstViewController = self.viewControllers.first {
            pageController.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
        }
        
        addChildViewController(pageController)
        
        view.addSubview(pageController.view)
        
        view.addSubview(skipButtonContainer)
        skipButtonContainer.addSubview(skipButton)
        skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
        skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18).isActive = true
        
        skipButtonContainer.addSubview(skipButton)
        skipButtonContainer.leadingAnchor.constraint(equalTo: skipButton.leadingAnchor).isActive = true
        skipButtonContainer.trailingAnchor.constraint(equalTo: skipButton.trailingAnchor).isActive = true
        skipButtonContainer.topAnchor.constraint(equalTo: skipButton.topAnchor).isActive = true
        skipButtonContainer.bottomAnchor.constraint(equalTo: skipButton.bottomAnchor).isActive = true
        
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextScreen), for: .touchUpInside)
        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18).isActive = true
        
        view.addSubview(stackViewSegmentedControl)
        stackViewSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackViewSegmentedControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -18).isActive = true
        let segmentControleHeightConstraint = stackViewSegmentedControl.heightAnchor.constraint(equalToConstant: 20)
        segmentControleHeightConstraint.priority = .defaultHigh
        segmentControleHeightConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Actions
    
    @objc private func skip() {
        let lastScreenIndex = viewControllers.count - 1
        if viewControllers.count > lastScreenIndex {
            pageController.setViewControllers([viewControllers[lastScreenIndex]], direction: .forward, animated: true, completion: nil)
            stackViewSegmentedControl.moveDotToEnd()
            showButtons(show: false)
        }
    }
    
    @objc private func nextScreen() {
        nextButton.isUserInteractionEnabled = false
        
        if let currentViewController = pageController.viewControllers?.first,
            let currentScreenIndex = viewControllers.index(of: currentViewController) {
            let nextScreen = currentScreenIndex + 1
            pageController.setViewControllers([viewControllers[nextScreen]], direction: .forward, animated: true, completion: nil)
            
            stackViewSegmentedControl.moveDotForward()
            
            if nextScreen == viewControllers.count - 1 {
                showButtons(show: false)
            }
        }
        
        nextButton.isUserInteractionEnabled = true
    }
    
    //MARK: Accessors
    
    private let viewControllers: [UIViewController]
    
    private lazy var pageController: UIPageViewController = {
        let pagecontroller = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return pagecontroller
    }()
    
    //Skips to last onboarding screen
    private lazy var skipButton: UIButton = {
        let skipbutton = UIButton()
        skipbutton.translatesAutoresizingMaskIntoConstraints = false
        skipbutton.setTitle("SKIP", for: .normal)
        skipbutton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        return skipbutton
    }()
    
    private lazy var skipButtonContainer: UIView = {
        let skipbuttoncontainer = UIView()
        skipbuttoncontainer.translatesAutoresizingMaskIntoConstraints = false
        return skipbuttoncontainer
    }()
    
    private lazy var nextButton: UIButton = {
        let nextbutton = UIButton()
        nextbutton.translatesAutoresizingMaskIntoConstraints = false
        nextbutton.setTitle("NEXT", for: .normal)
        nextbutton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        return nextbutton
    }()
    
    private lazy var stackViewSegmentedControl: StackViewSegmentControl = {
        let stackviewsegmentedcontrol = StackViewSegmentControl(segments: 3)
        stackviewsegmentedcontrol.translatesAutoresizingMaskIntoConstraints = false
        stackviewsegmentedcontrol.isUserInteractionEnabled = true
        return stackviewsegmentedcontrol
    }()
    
    //MARK: UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.index(of: viewController), index != 0
        {
            return viewControllers[index - 1]
        }
        return nil;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = viewControllers.index(of: viewController), index != viewControllers.count - 1  {
            return viewControllers[index + 1]
        }
        return nil
    }
    
    //MARK: UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let previousViewController = previousViewControllers.first,
            let currentViewController = pageViewController.viewControllers?.first,
            let previousViewControllerIndex = viewControllers.index(of: previousViewController),
            let currentViewControllerIndex = viewControllers.index(of: currentViewController) {
            
            if previousViewControllerIndex == currentViewControllerIndex {
                return
            }
            
            if currentViewControllerIndex == viewControllers.count - 1 {
                showButtons(show: false)
            } else if previousViewControllerIndex == viewControllers.count - 1 {
                showButtons(show: true)
            }
            
            if currentViewControllerIndex > previousViewControllerIndex {
                stackViewSegmentedControl.moveDotForward()
            } else {
                stackViewSegmentedControl.moveDotBackward()
            }
        }
    }
    
    //MARK: Helpers
    
    func showButtons(show: Bool) {
        skipButton.isUserInteractionEnabled = show == true
        nextButton.isUserInteractionEnabled = show == true
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.nextButton.alpha = show ? 1.0 : 0.0
            self.skipButton.alpha = show ? 1.0 : 0.0
        })
    }
}
