//
//  Player.swift
//  Project34
//
//

import GameplayKit
import UIKit

class Player: NSObject, GKGameModelPlayer {
	var chip: ChipColor
	var color: UIColor
	var username: String
	var playerId: Int
 let destinationPath = NSTemporaryDirectory() + "username.txt"
    var textname: String!
    
	static var allPlayers = [Player(chip: .blue), Player(chip: .gray)]

	var opponent: Player {
		if chip == .blue {
			return Player.allPlayers[1]
		} else {
			return Player.allPlayers[0]
		}
	}

	init(chip: ChipColor) {
		self.chip = chip
		self.playerId = chip.rawValue

		if chip == .blue {
			color = .blue
            do{
                var userNameData = try NSData(contentsOfFile: destinationPath) as Data
                for i in 0..<userNameData.count{
                    userNameData[i] -= 1
                }
                textname = String(data: userNameData, encoding: String.Encoding.utf8)
            }catch{
                print("error")
            }
			username = textname
		} else {
			color = .gray
			username = "CPU"
		}

		super.init()
	}
}
