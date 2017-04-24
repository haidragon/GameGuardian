//********************************************************************
//  GameListController.swift
//  GameKeeper
//  Created by Phil on 4/19/17
//
//  Description: Display list of all games
//********************************************************************

import UIKit
import CoreData

class GameListController: UIViewController{
    var managedContext: NSManagedObjectContext!
    var games: [Game] = []
    // nil until row is selected
    var selectedGame: Game?
    
    @IBOutlet weak var tableView: UITableView!
    
    //********************************************************************
    // addGameButtonPressed
    // Description: Segue to GameDetail with nil game property
    //********************************************************************
    @IBAction func addGameButtonPressed(_ sender: UIBarButtonItem) {
        // Show in code to avoid confusing segues in storyboard
        let addGameController = storyboard!.instantiateViewController(withIdentifier: "AddGame") as! AddGameController
        addGameController.managedContext = managedContext
        navigationController?.show(addGameController, sender: self)
    }
    
    //********************************************************************
    // viewWillAppear
    // Description: Reload table from Core Data model
    //********************************************************************
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTone()
        loadGames()
    }
    
    //********************************************************************
    // setTone
    // Description: Style screen based on tone
    //********************************************************************
    func setTone(){
        if TONE == .light{
            tableView.backgroundColor = UIColor.white
        }else{
            tableView.backgroundColor = UIColor.black
        }
    }
    
    //********************************************************************
    // loadGames
    // Description: Load games from core data
    //********************************************************************
    func loadGames(){
        let sortDescriptor = NSSortDescriptor(key: "dateStarted", ascending: false)
        let fetchRequest = NSFetchRequest<Game>(entityName: "Game")
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            games = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        }catch let error as NSError{
            print(error)
        }
    }
    
    //********************************************************************
    // gameDetailDidReturn
    // Description: Unwind segue for coming back from Game Detail
    //********************************************************************
    @IBAction func gameDetailDidReturn(sender: UIStoryboardSegue){
    }
    
    //********************************************************************
    // prepare(for:sender)
    // Description: Pass game and managed context to Game Detail
    //********************************************************************
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameDetail"{
            let gameDetailController = segue.destination as! GameDetailController
            gameDetailController.game = selectedGame
            gameDetailController.managedContext = managedContext
        }
    }
}

extension GameListController: UITableViewDataSource, UITableViewDelegate{
    //********************************************************************
    // tableView(numberOfRowsInSection)
    // Description: return number of games
    //********************************************************************
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    //********************************************************************
    // tableView(cellforRowAt)
    // Description: Configure default style cell
    //********************************************************************
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell")!
        cell.textLabel!.text = games[indexPath.row].name
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        cell.detailTextLabel!.text = dateFormatter.string(from: games[indexPath.row].dateStarted as! Date)
        // Style based on tone
        if TONE == .light{
            cell.backgroundColor = UIColor.white
            cell.textLabel!.textColor = UIColor.black
        }else{
            cell.backgroundColor = UIColor.black
            cell.textLabel!.textColor = UIColor.white
        }
        return cell
    }
    
    //********************************************************************
    // tableView(didSelectRowAt)
    // Description: Save selected game and run segue
    //********************************************************************
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGame = games[indexPath.row]
        performSegue(withIdentifier: "GameDetail", sender: self)
    }
    
    //********************************************************************
    // tableView(commit:forRowAt)
    // Description: allow deletion
    //********************************************************************
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        managedContext.delete(games[indexPath.row])
        games.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        do{
            try managedContext.save()
        }catch let error as NSError{
            print(error)
        }
    }
    
    //********************************************************************
    // tableView(heightForRowAt)
    // Description: Dynamic row sizing for all devices
    //********************************************************************
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT * 0.09
    }
}
