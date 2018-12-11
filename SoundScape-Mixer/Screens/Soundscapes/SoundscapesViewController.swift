import RealmSwift
import UIKit

class SoundscapesViewController: UIViewController {
    @IBOutlet var soundscapesCollectionView: UICollectionView!

    var reuseId = "soundscapesCollectionViewCell"

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
        soundscapesObserverToken = soundscapes?.observe(
            { _ in
                self.soundscapesCollectionView.reloadData()
            }
        )
    }
}

extension SoundscapesViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
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
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let soundscapeViewController = CreateSoundscapeViewController()
        soundscapeViewController.newSoundscape = false
        soundscapeViewController.soundscape = soundscapes[indexPath.row]
        navigationController?.pushViewController(soundscapeViewController, animated: true)
    }
}

extension SoundscapesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    ) -> CGSize {
        let width = soundscapesCollectionView.bounds.width / 2 - 10
        return CGSize(width: width, height: width)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 16.0
    }
}
