//
//  SceneDelegate.swift
//  VKWeatherApp
//
//  Created by nastasya on 17.07.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let navigationViewController = UINavigationController(rootViewController: WeatherViewController())
        navigationViewController.navigationBar.prefersLargeTitles = true
        navigationViewController.navigationBar.isTranslucent = true
        window?.rootViewController = navigationViewController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

