//********************************************************************
//  PlayerCell.swift
//  GameKeeper
//  Created by Phil on 4/19/17
//
//  Description: Hold game data for single player
//********************************************************************

import UIKit

class PlayerCell: UITableViewCell {
    var player: Player!{
        didSet{
            setUpCell()
        }
    }
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    //********************************************************************
    // setUpCell
    // Description: Initialize cell with player's data
    //********************************************************************
    func setUpCell(){
        nameLabel.text = player.name
        scoreLabel.text = String(player.score)
        setTone()
    }
    
    //********************************************************************
    // setTone
    // Description: Style screen based on tone
    //********************************************************************
    func setTone(){
        self.backdrop.image = (TONE == .light) ? #imageLiteral(resourceName: "CellLight") : #imageLiteral(resourceName: "CellDark")
        self.nameLabel.textColor = (TONE == .light) ? UIColor.black : UIColor.white
        self.scoreLabel.textColor = (TONE == .light) ? UIColor.black : UIColor.white
    }

}
