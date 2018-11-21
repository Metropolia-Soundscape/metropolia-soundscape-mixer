//
//  AudioRecorderVC.swift
//  SoundScape-Mixer
//
//  Created by Long Nguyen on 18/11/2018.
//  Copyright © 2018 Long Nguyen. All rights reserved.
//

// MARK: -Dependencies

import Foundation
import AVFoundation
import UIKit

// MARK: AudioRecorderVC class Implementation
class AudioRecorderVC: UIViewController {
    
    // MARK: Properties
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var hasPermission: Bool = false
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
    
    // MARK: Subviews
    
    @IBOutlet weak var recordBtn: UIButton!
    
    @IBOutlet weak var pauseBtn: UIButton!
    
    lazy var cancelBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnPressed))
        return btn
    }()
    
    lazy var saveBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveBtnPressed))
        btn.isEnabled = false
        return btn
    }()
    
    // MARK: Object lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup recorder
        
        recordingSession = AVAudioSession.sharedInstance()
        
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            
            self.hasPermission = hasPermission

        }
        
        setupView()
    }
    
    // MARK: Utils
    
    private func setupView() {
        self.navigationItem.title = "Recorder"
        self.navigationItem.leftBarButtonItem = cancelBtn
        self.navigationItem.rightBarButtonItem = saveBtn
    }
    
    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        print(paths[0])
        
        return paths[0]
    }
    
    private func showAlert(text: String) {
        let alertVC = UIAlertController()
        
        alertVC.title = "Infomation"
        alertVC.message = text
        
        alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: IBActions
    
    @IBAction func recordBtnPressed(_ sender: Any) {
        
        // Check if we already started audio and permission
        
        if audioRecorder == nil && self.hasPermission {
            let fileName = getDocumentDirectory().appendingPathComponent("\(UUID().uuidString).m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
            ]
            
            // Start audio recording
            
            do {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
                try recordingSession.setActive(true)
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.prepareToRecord()
                audioRecorder.record()
                
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
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveBtnPressed() {
        print("Save btn pressed")
    }
    
    @IBAction func pauseBtnPressed(_ sender: Any) {
        
        if audioRecorder != nil {
            if isRecording {
                self.isPaused = true
                self.isRecording = false
                self.audioRecorder.pause()
            } else {
                self.audioRecorder.record()
                self.isPaused = false
                self.isRecording = true
            }
        }
        
    }
    
}

// MARK: AVAudioRecorderDelegate

extension AudioRecorderVC: AVAudioRecorderDelegate {
    
}
