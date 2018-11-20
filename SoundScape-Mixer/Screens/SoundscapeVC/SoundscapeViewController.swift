import UIKit

// MARK: SoundscapeViewController Implementation
class SoundscapeViewController: UIViewController {
    // MARK: - IBOutlets

    @IBOutlet var recorderBtn: UIButton!

    @IBOutlet var musicLibraryBtn: UIButton!

    // MARK: -Object lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: IBActions

    @IBAction func audioBtnPressed(_: Any) {
        let audioVC = AudioRecorderVC()

        let navVC = UINavigationController(rootViewController: audioVC)

        present(navVC, animated: true, completion: nil)
    }

    @IBAction func musicLibraryPressed(_: UIButton) {
        print("Music playlist starts")
    }
}
