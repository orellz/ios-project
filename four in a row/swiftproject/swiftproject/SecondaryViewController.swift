//
//  SecondaryViewController.swift
//  swiftproject
//
//  Created by hackeru on 31/07/2018.
//  Copyright © 2018 orel. All rights reserved.
//

import GameplayKit
import UIKit

enum ChipColor: Int {
    case none = 0
    case blue
    case gray
    
}

class SecondaryViewController: UIViewController{
@IBOutlet var columnButtons: [UIButton]!
@IBOutlet var barlabel: UILabel!
    
     let destinationPath = NSTemporaryDirectory() + "username.txt"
    
var placedChips = [[UIView]]()
var board: Board!
var textname: String!
    
var strategist: GKMinmaxStrategist!

    override func viewDidLoad() {
    super.viewDidLoad()
        
        barlabel.text = "BEGIN"
        barlabel.font = UIFont.boldSystemFont(ofSize: 30)
    
    strategist = GKMinmaxStrategist()
    strategist.maxLookAheadDepth = 7
    strategist.randomSource = nil
    
    for _ in 0 ..< Board.width {
        placedChips.append([UIView]())
    }
    
    resetBoard()
}

func resetBoard() {
    board = Board()
    strategist.gameModel = board
    
    updateUI()
    
    for i in 0 ..< placedChips.count {
        for chip in placedChips[i] {
            chip.removeFromSuperview()
        }
        
        placedChips[i].removeAll(keepingCapacity: true)
    }
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

}

@IBAction func makeMove(_ sender: UIButton) {
    let column = sender.tag
    
    if let row = board.nextEmptySlot(in: column) {
        board.add(chip: board.currentPlayer.chip, in: column)
        addChip(inColumn: column, row: row, color: board.currentPlayer.color)
        continueGame()
    }
}

    func namechenge()  {
        
        do{
            var userNameData = try NSData(contentsOfFile: destinationPath) as Data
            for i in 0..<userNameData.count{
                userNameData[i] -= 1
            }
            textname = String(data: userNameData, encoding: String.Encoding.utf8)
        }catch{
            print("error")
            
            textname = "player 1"
        }
        
    }
    
func addChip(inColumn column: Int, row: Int, color: UIColor) {
    let button = columnButtons[column]
    let size = min(button.frame.width, button.frame.height / 6)
    let rect = CGRect(x: 0, y: 0, width: size, height: size)
    
    if (placedChips[column].count < row + 1) {
        let newChip = UIView()
        newChip.frame = rect
        newChip.isUserInteractionEnabled = false
        newChip.backgroundColor = color
        newChip.layer.cornerRadius = size / 2
        newChip.center = positionForChip(inColumn: column, row: row)
        newChip.transform = CGAffineTransform(translationX: 0, y: -800)
        view.addSubview(newChip)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            newChip.transform = CGAffineTransform.identity
        })
        
        placedChips[column].append(newChip)
    }
}

func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
    let button = columnButtons[column]
    let size = min(button.frame.width, button.frame.height / 6)
    
    let xOffset = button.frame.midX
    var yOffset = button.frame.maxY - size / 2
    yOffset -= size * CGFloat(row)
    return CGPoint(x: xOffset, y: yOffset)
}

func updateUI() {
    title = "\(board.currentPlayer.username)'s Turn"
    
    if board.currentPlayer.chip == .gray {
        startAIMove()
    }
}

func continueGame() {
    
    var gameOverTitle: String? = nil
    
    
    if board.isWin(for: board.currentPlayer) {
        gameOverTitle = "\(board.currentPlayer.username) Wins!"
    } else if board.isFull() {
        gameOverTitle = "Draw!"
    }
    
    
    if gameOverTitle != nil {
        let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Repaly", style: .default) { [unowned self] (action) in
            self.resetBoard()
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true)
        
        return
    }
    
    
    board.currentPlayer = board.currentPlayer.opponent
    updateUI()
}

func columnForAIMove() -> Int? {
    if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
        return aiMove.column
    }
    
    return nil
}

func makeAIMove(in column: Int) {
    columnButtons.forEach { $0.isEnabled = true }
     barlabel.text = "CPU"
    
   
  
    
    
    if let row = board.nextEmptySlot(in: column) {
        board.add(chip: board.currentPlayer.chip, in: column)
        addChip(inColumn: column, row:row, color: board.currentPlayer.color)
        
        continueGame()
    }
}

func startAIMove() {
    columnButtons.forEach { $0.isEnabled = false }
      namechenge()
     barlabel.text = textname
    

    DispatchQueue.global().async { [unowned self] in
        let strategistTime = CFAbsoluteTimeGetCurrent()
        guard let column = self.columnForAIMove() else { return }
        let delta = CFAbsoluteTimeGetCurrent() - strategistTime
        
        let aiTimeCeiling = 1.0
        let delay = aiTimeCeiling - delta
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.makeAIMove(in: column)
        }
    }
}
}



