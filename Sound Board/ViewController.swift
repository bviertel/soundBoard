//
//  ViewController.swift
//  Sound Board
//
//  Created by Brandon Viertel on 5/17/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // Create a Sound array to populate list from Core Data
    
    var sounds : [Sound] = []
    
    // Created our own Audio Player of type AVAudioPlayer
    
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {

        super.viewDidLoad()

        tableView.dataSource = self
        
        tableView.delegate = self
        
    }
    
    // Populates the Table View via fetch requests. Don't forget to reload the data!
    override func viewWillAppear(_ animated: Bool) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            
            // Recheck the data by fetching
            
            sounds = try context.fetch(Sound.fetchRequest())
            
            // Reload the data, and repopulate the Table View
            
            tableView.reloadData()
            
        } catch {
            
            // Nothing to be caught...
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sounds.count
    
    }
    
    // What the display of each cell in the Table View is going to look like
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = UITableViewCell()
        
        let sound = sounds[indexPath.row]
    
        cell.textLabel?.text = sound.name
        
        return cell
        
    }
    
    // When a cell is selected
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Locate sound to be played
        
        let sound = sounds[indexPath.row]
        
        // When selected play the audio
        
        do {
            
            // Don't forget to convert the data to 'as! Data'!
            // Audio Player is developer created (Me), AVAudioPlayer is Apple created
            
            audioPlayer = try AVAudioPlayer(data: sound.audio as! Data)
            
            // Plays the audio data
            
            audioPlayer?.play()
            
        } catch {
            
        }
        
        // Unhighlights the selected row
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // Deleting an object, particularly that of the swipe to delete
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Editing style is the swipe to delete
        
        if editingStyle == .delete {
            
            // Find the sound
            
            let sound = sounds[indexPath.row]
            
            // Context stuff
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // DEEELETE! the sound
            
            context.delete(sound)
            
            // Save the delete
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            // Don't forget the Do Try around the fetchRequest!
            
            do {
                
                // Recheck the data by fetching
                
                sounds = try context.fetch(Sound.fetchRequest())
                
                // Reload the data, and repopulate the Table View
                
                tableView.reloadData()
                
            } catch {
                
                // Nothing to be caught...
                
            }
 
        }
        
    }

}

