//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Anastasiia on 29.11.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        if hasCompletedOnboarding {
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
