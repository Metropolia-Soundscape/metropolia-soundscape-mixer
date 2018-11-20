//
//  MainTabBarController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/11/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

// MARK: Dependencies

import UIKit

// MARK: MainTabBarController Implementation

class MainTabBarController: UITabBarController {
    
    // MARK: Object lifecycle
    override func viewDidLoad() {
        
        setupVC()
    }
    
    // MARK: Setup methods
    
    private func setupVC() {
        let libraryVC = templateViewController(unselectedImage: UIImage(named: "circle")!, title: "Library", rootViewController: LibraryViewController())
        let soundscapesVC = templateViewController(unselectedImage: UIImage(named: "star")!, title: "Soundscapes", rootViewController: SoundscapesViewController())
        
        tabBar.tintColor = UIColor.tabBarTintColor()
        tabBar.isTranslucent = false
        
        viewControllers = [soundscapesVC, libraryVC]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    // MARK: Utils
    
    private func templateViewController(unselectedImage: UIImage, title: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        let font = UIFont(name: "Avenir-Heavy", size: 9)!
        navController.tabBarItem.image = unselectedImage
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
        navController.tabBarItem.title = title
        return navController
    }
}
