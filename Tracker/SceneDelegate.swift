//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Anastasiia on 29.11.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let userDefaultsService = UserDefaultsService.shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        if userDefaultsService.hasCompletedOnboarding {
            window.rootViewController = TabBarController()
        } else {
            window.rootViewController = OnboardingViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal,
                options: nil
            )
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
