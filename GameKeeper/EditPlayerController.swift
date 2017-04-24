//********************************************************************
//  EditPlayerController.swift
//  GameKeeper
//  Created by Phil on 4/19/17
//
//  Description: Hold game data for single player
//********************************************************************

import UIKit

class EditPlayerController: UIViewController{
    var player: Player!
    var addValue: Int64 = 0{
        didSet{
            // Invalid
            if addValue < 0{
                addButton.isEnabled = false
                addValueLabel.isEnabled = false
            }
        }
    }
    var subtractValue: Int64 = 0{
        didSet{
            // Invalid
            if subtractValue < 0{
                subtractButton.isEnabled = false
                subtractValueLabel.isEnabled = false
            }
        }
    }
    var changeValue: Int64 = 0{
        didSet{
            // Invalid
            if changeValue < 0{
                changeButton.isEnabled = false
                changeValueLabel.isEnabled = false
            }
        }
    }
    
    @IBOutlet weak var visibleView: UIView!
    @IBOutlet weak var cellBackdrop: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var addValueLabel: UILabel!
    @IBOutlet weak var subtractValueLabel: UILabel!
    @IBOutlet weak var changeValueLabel: UILabel!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        player.score = addValue
        dismissAnimate{
            self.performSegue(withIdentifier: "EditPlayerFinished", sender: self)
        }
    }
    @IBAction func subtractButtonPressed(_ sender: UIButton) {
        player.score = subtractValue
        dismissAnimate{
            self.performSegue(withIdentifier: "EditPlayerFinished", sender: self)
        }
    }
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        player.score = changeValue
        dismissAnimate{
            self.performSegue(withIdentifier: "EditPlayerFinished", sender: self)
        }
    }
    @IBAction func textFieldChanged(_ sender: UITextField) {
        guard !sender.text!.isEmpty else{
            return
        }
        enableButtons(true)
        calculateValues()
    }
    
    //********************************************************************
    // calculateValue
    // Description: Calculate new value for each button and show in label
    //********************************************************************
    func calculateValues(){
        let textFieldValue = Int64(textField.text!)!
        addValue = player.score + textFieldValue
        addValueLabel.text = String(addValue)
        
        subtractValue = player.score - textFieldValue
        subtractValueLabel.text = String(subtractValue)
        
        changeValue = textFieldValue
        changeValueLabel.text = String(changeValue)
    }
    
    //********************************************************************
    // viewDidLoad
    // Description: Set background color for pop up
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.textField.becomeFirstResponder()
        }
        
        // Set up tap to close gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.view.addGestureRecognizer(tap)
        
        // Set up keybaord recognizers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
    //********************************************************************
    // viewWillAppear
    // Description: Ensure view is not visible before positioning above keyboard
    //********************************************************************
    override func viewWillAppear(_ animated: Bool) {
        // Set initial scale and alpha
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
    }
    
    //********************************************************************
    // viewWillAppear
    // Description: Set height of keyboard if possible
    //********************************************************************
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // For some reason did not work in viewWillAppear or viewDidLoad
        // If keyboardHeight was previously calculated set view to that height
        let keyboardHeight = UserDefaults.standard.float(forKey: "KeyboardHeight")
        if  keyboardHeight != 0{
            setUpAlert()
            showAnimate()
        }
    }
    
    //********************************************************************
    // keybaordDidShow(notification)
    // Description: Calculate height of keyboard and save for future use. First
    // time will be slow because need to wait for notification
    //********************************************************************
    func keyboardDidShow(notification: Notification){
        let keyboardSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        let savedKeyboardHeight = UserDefaults.standard.float(forKey: "KeyboardHeight")
        // Height not yet saved
        if savedKeyboardHeight == 0{
            setUpAlert()
            showAnimate()
        }
        // Save height for future
        UserDefaults.standard.set((keyboardSize.height), forKey: "KeyboardHeight")
    }
    
    //********************************************************************
    // handleTap
    // Description: Close view if touched right spot
    //********************************************************************
    func handleTap(sender: UITapGestureRecognizer){
        let tapLocation = sender.location(in: self.view)
        // Tap is above visible view
        if tapLocation.y < visibleView.frame.minY{
            dismissAnimate{
                self.performSegue(withIdentifier: "EditPlayerFinished", sender: self)
            }
        }
    }
    
    //********************************************************************
    // setUpAlert
    // Description: Show Alert
    //********************************************************************
    func setUpAlert(){
        cellBackdrop.image = (TONE == .light) ? #imageLiteral(resourceName: "CellLight") : #imageLiteral(resourceName: "CellDark")
        nameLabel.textColor = (TONE == .light) ? UIColor.black : UIColor.white
        nameLabel.text = player.name
        scoreLabel.textColor = (TONE == .light) ? UIColor.black : UIColor.white
        scoreLabel.text = String(player.score)
        enableButtons(false)
    }
    
    //********************************************************************
    // showAnimate
    // Description: Animate popup on appearing
    //********************************************************************
    func showAnimate(){
        DispatchQueue.main.async {
            // Set height of view
            let savedKeyboardHeight = CGFloat(UserDefaults.standard.float(forKey: "KeyboardHeight"))
            self.visibleView.center.y = (SCREEN_HEIGHT - savedKeyboardHeight) - (self.visibleView.frame.height / 2)
            // Fade in and shrink
            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
    }
    
    //********************************************************************
    // dismissAnimate
    // Description: Animate popup on dismiss
    //********************************************************************
    func dismissAnimate(completion: @escaping () -> Void = {}){
        DispatchQueue.main.async {
            // Possibly not needed
            self.resignFirstResponder()
            // Fade out and grow
            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 0.0
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {
                finished in
                if finished{
                    self.view.removeFromSuperview()
                    completion()
                }
            })
        }
    }
    
    //********************************************************************
    // enableButtons(flag)
    // Description: Enable or disable all buttons at once
    //********************************************************************
    func enableButtons(_ flag: Bool){
        addButton.isEnabled = flag
        addValueLabel.isEnabled = flag
        subtractButton.isEnabled = flag
        subtractValueLabel.isEnabled = flag
        changeButton.isEnabled = flag
        changeValueLabel.isEnabled = flag
    }
}
