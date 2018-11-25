import AVFoundation
import Foundation
import UIKit

class AudioRecorderVC: UIViewController {
    @IBOutlet var recordBtn: UIButton!
    @IBOutlet var pauseBtn: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var hasPermission: Bool = false
    @IBOutlet weak var timerLbl: UILabel!
    var meterTimer:Timer!
    
    private var isRecording = false {
        didSet {
            if isRecording {
                pauseBtn.isEnabled = true
            } else {
                if audioRecorder == nil {
                    recordBtn.setTitle("Start recording", for: .normal)
                    pauseBtn.isEnabled = false
                    pauseBtn.setTitle("Pause", for: .normal)
                } else {
                    pauseBtn.setTitle("Resume", for: .normal)
                }
            }
        }
    }

    private var isPaused = false {
        didSet {
            if isPaused {
                pauseBtn.setTitle("Resume", for: .normal)
            } else {
                pauseBtn.setTitle("Pause", for: .normal)
            }
        }
    }

    private var isFinishedRecording = false {
        didSet {
            if isFinishedRecording {
                saveBtn.isEnabled = true
            } else {
                saveBtn.isEnabled = false
            }
        }
    }

    lazy var cancelBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnPressed))
        return btn
    }()

    lazy var saveBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveBtnPressed))
        btn.isEnabled = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { hasPermission in
            self.hasPermission = hasPermission
        }

        setupView()
    }

    private func setupView() {
        navigationItem.title = "Recorder"
        navigationItem.leftBarButtonItem = cancelBtn
        navigationItem.rightBarButtonItem = saveBtn
    }

    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        print(paths[0])

        return paths[0].appendingPathComponent("Resources/Records/")
    }

    private func showAlert(text: String) {
        let alertVC = UIAlertController()

        alertVC.title = "Infomation"
        alertVC.message = text

        alertVC.addAction(
            UIAlertAction(
                title: "Close", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }
            )
        )

        present(alertVC, animated: true, completion: nil)
    }

    @IBAction func recordBtnPressed(_: Any) {
        if audioRecorder == nil && hasPermission {
            let fileName = getDocumentDirectory().appendingPathComponent("\(UUID().uuidString).m4a")

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            ]

            do {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
                try recordingSession.setActive(true)
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
                
                
                meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)

                recordBtn.setTitle("Stop recording", for: .normal)

                isRecording = true
            } catch let err {
                print(err.localizedDescription)
            }
        } else {
            audioRecorder.stop()
            audioRecorder = nil

            isRecording = false
        }
    }

    @objc private func cancelBtnPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func saveBtnPressed() {
        print("Save btn pressed")
    }
    
    @objc private func updateAudioMeter(timer: Timer) {
        if let audioRecorder = self.audioRecorder {
            
            if audioRecorder.isRecording {
                let hr = Int((audioRecorder.currentTime / 60) / 60)
                let min = Int(audioRecorder.currentTime / 60)
                let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
                let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
                timerLbl.text = totalTimeString
                audioRecorder.updateMeters()
                
                if sec >= 30 {
                    // Stop the recorder

                    self.audioRecorder.stop()
                    self.audioRecorder = nil

                    isRecording = false
                }
            }
        
        }
    }

    @IBAction func pauseBtnPressed(_: Any) {
        if audioRecorder != nil {
            if isRecording {
                isPaused = true
                isRecording = false
                audioRecorder.pause()
            } else {
                audioRecorder.record()
                isPaused = false
                isRecording = true
            }
        }
    }
}

extension AudioRecorderVC: AVAudioRecorderDelegate {
    
}
