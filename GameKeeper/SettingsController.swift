//********************************************************************
//  SettingsController.swift
//  GameKeeper
//  Created by Phil on 4/20/17
//
//  Description: Settings for overall app
//********************************************************************

import UIKit
import AVFoundation

class SettingsController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var lightImageView: UIImageView!
    @IBOutlet weak var toneSwitch: UISwitch!
    var soundPlayer: AVAudioPlayer?
    
    @IBAction func switchFlipped(_ sender: UISwitch) {
        TONE = sender.isOn ? .light : .dark
        UserDefaults.standard.set(TONE.rawValue, forKey: "Tone")
        playSound("LightSwitch", ofType: "wav")
        setTone()
    }
    
    //********************************************************************
    // viewDidLoad
    // Description: Set up slider
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        toneSwitch.onTintColor = UIColor.white
        // Workaround to set off tint color
        toneSwitch.backgroundColor = UIColor.black
        toneSwitch.layer.cornerRadius = 16.0
        setTone()
    }
    
    //********************************************************************
    // setTone
    // Description: Called each time switch is changed to style screen
    //********************************************************************
    func setTone(){
        self.view.backgroundColor = (TONE == .light) ? UIColor.white : UIColor.black
        titleLabel.textColor = (TONE == .light) ? UIColor.black : UIColor.white
        subTitle.textColor = (TONE == .light) ? UIColor.black : UIColor.white
        lightImageView.image = (TONE == .light) ? #imageLiteral(resourceName: "LightOn") : #imageLiteral(resourceName: "LightOff")
        toneSwitch.isOn = (TONE == .light)
    }
    
    //********************************************************************
    // playSound
    // Description: Play light sound
    //********************************************************************
    func playSound(_ soundName: String, ofType soundType: String){
        let soundURL = NSURL.fileURL(withPath: Bundle.main.path(forResource: soundName, ofType: soundType)!)
        do{
            soundPlayer = try AVAudioPlayer(contentsOf: soundURL)
            guard let soundPlayer = soundPlayer else{return}
            soundPlayer.prepareToPlay()
            soundPlayer.play()
        }catch{
            print("Could not play sound")
        }
    }

}
