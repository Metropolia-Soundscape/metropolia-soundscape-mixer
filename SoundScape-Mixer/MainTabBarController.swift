//
//  MainTabBarController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/11/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        let libraryViewController = LibraryViewController(nibName: String(describing: LibraryViewController.self), bundle: nil)
//        let libraryNavController = UINavigationController(rootViewController: libraryViewController)
        let soundscapesViewController = SoundscapesViewController(nibName: String(describing: SoundscapesViewController.self), bundle: nil)
//        let soundscapesNavController = UINavigationController(rootViewController: soundscapesViewController)
        let viewControllerList = [soundscapesViewController, libraryViewController]
        
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0)}
    }
}