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
    }
    
    // MARK: - Private Methods
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
