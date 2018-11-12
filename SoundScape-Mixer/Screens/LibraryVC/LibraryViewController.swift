//
//  LibraryViewController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/9/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var libraryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private let reuseId = "categoryCollectionViewCell"
    let items = ["Human", "Machine", "Nature"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        tabBarItem = UITabBarItem(title: "Library", image: nil, selectedImage: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CategoryCollectionViewCell
        
        cell.displayContent(name: items[indexPath.row])
        cell.backgroundColor = UIColor.red
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(items[indexPath.row])
        let audioViewController = AudioViewController()
        audioViewController.category = items[indexPath.row]
        self.navigationController?.pushViewController(audioViewController, animated: true)
    }
}
