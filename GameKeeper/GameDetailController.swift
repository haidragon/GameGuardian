//********************************************************************
//  GameDetailController.swift
//  GameKeeper
//  Created by Phil on 4/19/17
//
//  Description: Screen the user sees while playing a game. Allow options to 
//  increment or decrement any player's score
//********************************************************************

import UIKit
import CoreData


class GameDetailController: UIViewController{
    var managedContext: NSManagedObjectContext!
    var game: Game!
    var playerArray: [Player] = []
    var newPlayerName: String?
    var centerButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    //********************************************************************
    // addPlayerButtonPressed
    // Description: Show alert to add player
    //********************************************************************
    @IBAction func addPlayerButtonPressed(_ sender: UIBarButtonItem) {
        addPlayerAlert()
    }
    
    //********************************************************************
    // addPlayerAlert
    // Description: Show alert to add player
    //********************************************************************
    func addPlayerAlert(){
        let alertController = UIAlertController(title: "Add New Player", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default){ _ in
            if let newPlayerName = alertController.textFields![0].text{
                if self.playerArray.isEmpty{
                    // Delete center button after first player is added
                    self.centerButton.removeFromSuperview()
                }
                self.createNewPlayer(name: newPlayerName)
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        alertController.addTextField(){ textField in
            textField.placeholder = "Player Name"
        }
        present(alertController, animated: true)
    }
    
    //********************************************************************
    // createNewPlayer
    // Description: Add new player to instance variable array and core data array
    // and load it in table
    //********************************************************************
    func createNewPlayer(name: String){
        // Create new player
        let newPlayer = Player(entity: Player.entity(), insertInto: self.managedContext)
        newPlayer.name = name
        newPlayer.score = 0
        // Add to swift player array
        self.playerArray.append(newPlayer)
        // Add to core data set
        self.game.addToPlayers(newPlayer)
        let insertPath = IndexPath(row: self.playerArray.count - 1, section: 0)
        self.tableView.insertRows(at: [insertPath], with: .automatic)
        save()
    }
    
    //********************************************************************
    // viewDidLoad
    // Description: Segue to AddGame when game property is nil (User tapped add game)
    //********************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        // Update swift array with core data players
        playerArray = game.players?.allObjects as! [Player]
        // Initial sort of players(since Set doesn't keep track of order)
        playerArray.sort{
            $0.score > $1.score
        }
    }
    
    //********************************************************************
    // viewWillAppear
    // Description: Display information on game
    //********************************************************************
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = game.name
        setTone()
        if playerArray.isEmpty{
            // Create button in center to add players
            centerButton = UIButton(frame: CGRect(x: SCREEN_WIDTH * 0.1, y: SCREEN_HEIGHT * 0.4, width: SCREEN_WIDTH * 0.8, height: SCREEN_HEIGHT * 0.1))
            centerButton.setTitle("No Players", for: .normal)
            centerButton.setTitleColor(COLOR_BLUE, for: .normal)
            centerButton.setTitleColor(COLOR_BLUE_FADED, for: .highlighted)
            centerButton.titleLabel?.font = UIFont(name: FONT_MAIN, size: 50)
            centerButton.layer.shadowColor = UIColor.black.cgColor
            centerButton.layer.shadowOffset = CGSize(width: 0, height: 1)
            centerButton.layer.shadowOpacity = 1.0
            centerButton.layer.shadowRadius = 1
            centerButton.addTarget(self, action: #selector(addPlayerAlert), for: .touchUpInside)
            self.view.addSubview(centerButton)
        }
    }
    
    //********************************************************************
    // setTone
    // Description: Style screen based on tone
    //********************************************************************
    func setTone(){
        self.tableView.backgroundColor = (TONE == .light) ? UIColor.white : UIColor.black
        // Reload to adjust tone for cells
        self.tableView.reloadData()
    }
    
    //********************************************************************
    // save
    // Description: Save new game to Core Data. Save after adding new game, 
    // adding new player, and after editing a player.
    //********************************************************************
    func save(){
        do{
            try managedContext.save()
        }catch let error as NSError{
            print(error)
        }
    }

    //********************************************************************
    // addGameAddedNewGame
    // Description: Unwind segue when user added new game
    //********************************************************************
    @IBAction func addGameAddedNewGame(sender: UIStoryboardSegue){
        if SHOW_ADS{
            Chartboost.showInterstitial(CBLocationHomeScreen)
            Chartboost.cacheInterstitial(CBLocationHomeScreen)
        }
        let addGameController = sender.source as! AddGameController
        let newGame = Game(entity: Game.entity(), insertInto: managedContext)
        newGame.name = addGameController.newGameName
        newGame.dateStarted = Date() as NSDate
        game = newGame
        // Save to Core Data
        save()
    }
    
    //********************************************************************
    // addGameCancelled
    // Description: Unwind segue when user added new game
    //********************************************************************
    @IBAction func addGameCancelled(sender: UIStoryboardSegue){
        // Remove game detail from nav stack
        let oldNavStack = navigationController!.viewControllers
        let newNavStack = [oldNavStack[0]]
        navigationController!.setViewControllers(newNavStack, animated: true)
    }
    
    //********************************************************************
    // editPlayerFinished
    // Description: Unwind segue when user exits edit player screen
    //********************************************************************
    @IBAction func editPlayerFinished(sender: UIStoryboardSegue){
        let editPlayerController = sender.source as! EditPlayerController
        let editedPlayer = editPlayerController.player!
        // Start assuming top player
        var insertIndex = 0
        // Climb up from bottom of Players until score is less than or equal to one
        for index in stride(from: playerArray.count - 1, through: 0, by: -1){
            // Found correct position
            if editedPlayer.score <= playerArray[index].score{
                // Insert player under
                insertIndex = index + 1
                break
            }
        }
        playerArray.insert(editedPlayer, at: insertIndex)
        tableView.insertRows(at: [IndexPath(row: insertIndex, section: 0)], with: .automatic)
        // Save to Core Data
        save()
    }
}

extension GameDetailController: UITableViewDataSource, UITableViewDelegate{
    //********************************************************************
    // tableView(numberOfRowsInSection)
    // Description: Return number of players in game
    //********************************************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerArray.count
    }
    
    //********************************************************************
    // tableView(cellForRowAt)
    // Description: Configure each cell with player's data
    //********************************************************************
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell") as! PlayerCell
        cell.player = playerArray[indexPath.row]
        return cell
    }
    
    //********************************************************************
    // tableView(didSelectRowAt)
    // Description: Add edit cell under player
    //********************************************************************
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        grabPlayerForEdit(atPath: indexPath, onTableView: tableView)
    }
    
    //********************************************************************
    // showAlertStandard
    // Description: Show alert with OK button
    //********************************************************************
    func grabPlayerForEdit(atPath indexPath: IndexPath, onTableView tableView: UITableView){
        // Remove player from table temporarily
        let player = playerArray[indexPath.row]
        playerArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        // Launch edit view
        DispatchQueue.main.async{
            let editView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditView") as! EditPlayerController
            // Pass variables
            editView.player = player
            // Set up aesthetics
            self.addChildViewController(editView)
            editView.view.frame = self.view.frame
            self.view.addSubview(editView.view)
            editView.didMove(toParentViewController: self)
        }
    }
    
    //********************************************************************
    // tableView(commit)
    // Description: Allow deleting players
    //********************************************************************
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        managedContext.delete(playerArray[indexPath.row])
        game.removeFromPlayers(playerArray[indexPath.row])
        playerArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        save()
    }
    
    //********************************************************************
    // tableView(heightForRowAt)
    // Description: Dynamic row sizing for all devices
    //********************************************************************
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT * 0.12
    }
}
