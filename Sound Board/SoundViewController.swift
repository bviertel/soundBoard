//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Brandon Viertel on 5/17/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

// Need for Audio/Video Recording

import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    // Used to disable buttons
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    // Initializing Audio Recorder and Audio Player
    
    var audioRecorder : AVAudioRecorder?
    
    var audioPlayer : AVAudioPlayer?
    
    // Location of the audio file
    
    var audioURL : URL?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpRecorder()
        
        // Buttons set to disabled so user cannot select before audio is captured
        
        playButton.isEnabled = false
        
        addButton.isEnabled = false
        
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
            
            // Created Dictionary because the settings section in the AVAudioRecorder class needed a type Dictionary. Can have many different options in the settings dictionary.
            
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
            
            addButton.isEnabled = true
            
        } else {
            
            // Start Recording
            
            audioRecorder!.record()
            
            // Change button to Stop
            
            recordButton.setTitle("Stop", for: .normal)
            
            
        }
        
    }
    
    // Plays the recently captured audio
    
    @IBAction func playTapped(_ sender: Any) {
        
        do {
            
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            
            audioPlayer!.play()
        
        } catch {
            
            // Nothing to be caught...
            
        }
        
    }
    
    // Adds to the Core Data
    
    @IBAction func addTapped(_ sender: Any) {
        
        // Context Stuff, for Core Data to hold, references as Context
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        
        sound.name = nameTextField.text!
        
        // Because audioURL is of type URL, it needs to be converted to that of NSData so that it can be stored in sound.audio which is of binary type
        
        sound.audio = NSData(contentsOf: audioURL!)
        
        // Save all the contextual stuff
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        // Pop back to main View Controller
        
        navigationController?.popViewController(animated: true)
    
    }
    
}
