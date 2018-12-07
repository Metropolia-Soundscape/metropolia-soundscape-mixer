import UIKit
import RealmSwift

class SoundscapesViewController: UIViewController {
    
    @IBOutlet weak var soundscapesCollectionView: UICollectionView!
    
    var reuseId = "soundscapesCollectionViewCell"

    let realm = try! Realm()
    var soundscapes: Results<Soundscape>!
    
    var soundscapesObserverToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Soundscapes"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem?.title = ""

        soundscapesCollectionView.register(UINib(nibName: "SoundscapesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseId)
        soundscapesCollectionView.dataSource = self
        soundscapesCollectionView.delegate = self
        soundscapes = realm.objects(Soundscape.self)
        soundscapesObserverToken = soundscapes?.observe({ (_) in
            self.soundscapesCollectionView.reloadData()
        })
    }
}

extension SoundscapesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let soundscapes = soundscapes {
            return soundscapes.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! SoundscapesCollectionViewCell
        if let soundscapes = soundscapes {
            cell.soundscapeNameLbl.text = soundscapes[indexPath.row].name
        }
        return cell
    }
}

extension SoundscapesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let soundscapeVC = CreateSoundscapeViewController()
        soundscapeVC.newSoundscape = false
        soundscapeVC.soundscape = soundscapes[indexPath.row]
        navigationController?.pushViewController(soundscapeVC, animated: true)
    }
}

extension SoundscapesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = soundscapesCollectionView.bounds.width/2 - 10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
}
