//
//  LibraryViewController.swift
//  SoundScape-Mixer
//
//  Created by Hồng Ngọc Doãn on 11/9/18.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

protocol LibraryViewControllerDelegate: class {
    func libraryViewController(_ viewController: UIViewController, didSelectAudio audio: Audio)
}

class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: LibraryViewControllerDelegate?
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    private let reuseId = "categoryCollectionViewCell"
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (self.presentingViewController != nil) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBtnPressed))
        } else {
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        title = "Library"
//        tabBarItem = UITabBarItem(title: "Library", image: nil, selectedImage: nil)
        navigationItem.title = "Library"
    }
    
    @objc private func cancelBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AudioCategory.allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CategoryCollectionViewCell
//        cell.displayContent(name: categories[indexPath.row].name)
        cell.categoryNameLabel.text = AudioCategory.allCategories[indexPath.row].rawValue.capitalized
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenSize.width)
        return CGSize(width: width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let audioViewController = AudioViewController()
        audioViewController.category = AudioCategory.allCategories[indexPath.row]
        audioViewController.delegate = self
        self.navigationController?.pushViewController(audioViewController, animated: true)
    }

}

extension LibraryViewController: AudioViewControllerDelegate {
    func audioViewControllerDidSelectAudio(_ controller: AudioViewController, didSelectAudio audio: Audio) {
        delegate?.libraryViewController(self, didSelectAudio: audio)
        dismiss(animated: true, completion: nil)
    }
}
