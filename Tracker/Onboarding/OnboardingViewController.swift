//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Anastasiia on 10.02.2025.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Private Properties
    private lazy var pages: [UIViewController] = {
        let firstPage = OnboardingPageViewController(
            image: "OnboardingBg 1",
            text: "Отслеживайте только то, что хотите"
        )
        firstPage.delegate = self
        
        let secondPage = OnboardingPageViewController(
            image: "OnboardingBg 2",
            text: "Даже если это не литры воды и йога"
        )
        secondPage.delegate = self
        
        return [firstPage, secondPage]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = UIColor.ypBlack.withAlphaComponent(0.3)
        return pageControl
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        configureView()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    private func configureView() {
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setupConstraints() {
        view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

extension OnboardingViewController: OnboardingPageViewControllerDelegate {
    func closeOnboardingPage() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        guard let window = UIApplication.shared.windows.first else { return }
        let tabBarController = TabBarController()
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = tabBarController
        }, completion: { _ in
            window.makeKeyAndVisible()
        })
    }
}
