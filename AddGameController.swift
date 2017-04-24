//********************************************************************
//  AddGameController.swift
//  GameKeeper
//  Created by Phil on 4/19/17
//
//  Description: User is adding a new game. Display text field where they
//  input the name of the new game.
//********************************************************************

import UIKit
import CoreData

class AddGameController: UIViewController {
    var managedContext: NSManagedObjectContext!
    var newGameName = "New Game"
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var gameNameField: UITextField!
    
    //********************************************************************
    // gameNameFieldChanged
    // Description: Check to make sure there is text in the field. Then allow
    // user to press done
    //********************************************************************
    @IBAction func gameNameFieldChanged(_ sender: UITextField) {
        guard !sender.text!.isEmpty else{
            return
        }
        newGameName = sender.text!
        doneButton.isEnabled = true
    }
    
    //********************************************************************
    // gameNameFieldDidEndOnExit
    // Description: dismiss keyboard and go back to game list
    //********************************************************************
    @IBAction func gameNameFieldDidEndOnExit(_ sender: UITextField) {
        resignFirstResponder()
        performSegue(withIdentifier: "AddGameControllerAddedNewGame", sender: self)
    }
    
    //********************************************************************
    // viewdidLoad
    // Description: Add gameDetailController in middle of nav stack to pop
    // back to it.
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false
        
        // Insert game detail in between gameList and addGame
        let gameDetailController = storyboard!.instantiateViewController(withIdentifier: "GameDetail") as! GameDetailController
        gameDetailController.managedContext = managedContext
        let oldNavStack = navigationController!.viewControllers
        let newNavStack = [oldNavStack[0], gameDetailController, oldNavStack[1]]
        navigationController!.setViewControllers(newNavStack, animated: false)
        
        // Set tone
        setTone()
    }
    
    //********************************************************************
    // viewDidAppear
    // Description: Show keyboard when screen launches
    //********************************************************************
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameNameField.becomeFirstResponder()
    }
    
    //********************************************************************
    // setTone
    // Description: Style screen based on tone
    //********************************************************************
    func setTone(){
        self.view.backgroundColor = TONE == .light ? UIColor.white : UIColor.black
    }

}
