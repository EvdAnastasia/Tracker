//
//  TabBarController.swift
//  Tracker
//
//  Created by Anastasiia on 01.12.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setAppearance()
    }
    
    // MARK: - Private Methods
    private func setAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = .ypBlue
        appearance.backgroundColor = .ypWhite
        
        let border = CALayer()
        border.backgroundColor = UIColor.ypGrayTabBar.cgColor
        border.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 0.5)
        tabBar.layer.addSublayer(border)
    
        tabBar.standardAppearance = appearance
    }
    
    private func setupViewControllers() {
        let trackersViewController = TrackersViewController()
        let trackersNavController = UINavigationController(rootViewController: trackersViewController)
        let tabTrackersText = NSLocalizedString("tab.trackers", comment: "First tab bar item text")
        trackersNavController.tabBarItem = UITabBarItem(
            title: tabTrackersText,
            image: UIImage(named: "TabTrackersActive"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        let tabStatisticsText = NSLocalizedString("tab.statistics", comment: "Second tab bar item text")
        statisticsViewController.tabBarItem = UITabBarItem(
            title: tabStatisticsText,
            image: UIImage(named: "TabStatisticsActive"),
            selectedImage: nil
        )
        
        self.viewControllers = [trackersNavController, statisticsViewController]
    }
}
