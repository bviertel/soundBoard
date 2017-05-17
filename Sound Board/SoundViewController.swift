//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Ann Marie Seyerlein on 5/17/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

// Need for Audio/Video Recording

import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    // Initializing Audio Recorder
    
    var audioRecorder : AVAudioRecorder?
    
    var audioPlayer : AVAudioPlayer?
    
    var audioURL : URL?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpRecorder()
        
        playButton.isEnabled = false
        
    }
    
    func setUpRecorder() {
        
        // Note the error handling
        
        do {
            
            // Create audio session
            
            let session = AVAudioSession.sharedInstance()
            
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            // Allows sound to go through devices speakers
            
            try session.overrideOutputAudioPort(.speaker)
            
            try session.setActive(true)
            
            // Create URL for audio file e.g. documents directory
            
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            let pathComponents = [basePath, "audio.m4a"]
            
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            /* print("#############")
            
            print(audioURL)
            
            print("#############") */
            
            // Create settings for Audio Recorder
            
            // Originally had AnyObject, but only needed Any
        
            var settings : [String : Any] = [:]
            
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            
            // Just a good number
            
            settings[AVSampleRateKey] = 44100.00
            
            settings[AVNumberOfChannelsKey] = 2
            
            // Create Audio Recorder Object
            // Whenever we record something, it has to save it to a file
            // URL is location of the stored audio
            
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            
            audioRecorder!.prepareToRecord()
            
            // Can catch multiple and specific errors
            
            //} catch let error as NSError {
            
            //print(error)
            
        } catch {
            
            
        }
        
    }
    
    @IBAction func recordButton(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            
            // Stop Recording
            
            audioRecorder?.stop()
            
            // Change button title to Record
            
            recordButton.setTitle("Record", for: .normal)
            
            // Enable Play button (Automatically disabled without recording)
            
            playButton.isEnabled = true
            
        } else {
            
            // Start Recording
            
            audioRecorder!.record()
            
            // Change button to Stop
            
            recordButton.setTitle("Stop", for: .normal)
            
            
        }
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do {
            
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            
            audioPlayer!.play()
        
        } catch {
            
            
            
        }
        
    
    }
    
    @IBAction func addTapped(_ sender: Any) {
    }
    
}
