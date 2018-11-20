//
//  LibraryViewController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/9/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    private let reuseId = "categoryCollectionViewCell"
//    let items = ["Human", "Machine", "Nature"]
    let realm = try! Realm()
    
    lazy var categories: Results<Category> = { self.realm.objects(Category.self) }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        tabBarItem = UITabBarItem(title: "Library", image: nil, selectedImage: nil)
        
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Library"
        populateDefaultCategories()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CategoryCollectionViewCell
        cell.displayContent(name: categories[indexPath.row].name)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width)
        return CGSize(width: width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let audioViewController = AudioViewController()
        audioViewController.category = categories[indexPath.row].name
        self.navigationController?.pushViewController(audioViewController, animated: true)
    }
    
    func populateDefaultCategories() {
        if categories.count == 0 {
            try! realm.write() {
                let defaultCategories = ["Human", "Machine", "Nature"]
                for category in defaultCategories {
                    let newCategory = Category()
                    newCategory.name = category
                    self.realm.add(newCategory)
                }
            }
            categories = realm.objects(Category.self)
        }
    }
}
