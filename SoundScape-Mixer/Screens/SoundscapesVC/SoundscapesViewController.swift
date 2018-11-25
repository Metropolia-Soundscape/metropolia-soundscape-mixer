//
//  SoundscapesViewController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/9/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

class SoundscapesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        title = "Soundscapes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setUpAddButton()
        tabBarItem = UITabBarItem(title: "Soundscapes", image: nil, selectedImage: nil)
    }
    
    @objc func addTapped() {
        let soundscapeViewController = CreateSoundscapeViewController()
        let navVC = UINavigationController(rootViewController: soundscapeViewController)
        self.present(navVC, animated: true, completion: nil)
    }
    
    func setUpAddButton() {
        let addButton = UIButton(type: .custom)
        addButton.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
        addButton.setImage(UIImage(named: "iconAdd"), for: .normal)
        addButton.addTarget(self, action: #selector(addTapped), for: UIControl.Event.touchUpInside)
        
        let addButtonItem = UIBarButtonItem(customView: addButton)
        let currWidth = addButtonItem.customView?.widthAnchor.constraint(equalToConstant: 40)
        currWidth?.isActive = true
        let currHeight = addButtonItem.customView?.heightAnchor.constraint(equalToConstant: 40)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = addButtonItem
    }
}
