import UIKit

class SoundscapesViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationItem.title = "Soundscapes"
        navigationController?.navigationBar.prefersLargeTitles = true

        setUpAddButton()
        tabBarItem = UITabBarItem(title: "Soundscapes", image: nil, selectedImage: nil)

        if let url = URL(string: "http://resourcespace.tekniikanmuseo.fi/filestore/2/8/2_9759fa45847ae7a/282_f1a7c8f3ba0fd75.wav?v=2015-11-23+13%3A42%3A18") {
            let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let desURL = docDirURL.appendingPathComponent(url.lastPathComponent)
            print(desURL)

            URLSession.shared.downloadTask(
                with: url, completionHandler: { (location, _, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        try FileManager.default.moveItem(at: location, to: desURL)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            ).resume()
        }
    }

    @objc func addTapped() {
//        let soundscapeViewController = SoundscapeViewController(appController: appController)
//        navigationController?.pushViewController(soundscapeViewController, animated: true)
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
        navigationItem.rightBarButtonItem = addButtonItem
    }
}
