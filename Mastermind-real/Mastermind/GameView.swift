//
//  GameView.swift
//  Mastermind
//
//  Created by Garrido, Joao on 28/10/2021.
//

import UIKit
import AVFoundation

//class for custom tableViewCell
class HintsTableViewCell: UITableViewCell{
    @IBOutlet weak var hint1: UIImageView!
    @IBOutlet weak var hint2: UIImageView!
    @IBOutlet weak var hint3: UIImageView!
    @IBOutlet weak var hint4: UIImageView!
}

//class for custom tableViewCell
class GameTableViewCell: UITableViewCell{
    @IBOutlet weak var color1: UIImageView!
    @IBOutlet weak var color2: UIImageView!
    @IBOutlet weak var color3: UIImageView!
    @IBOutlet weak var color4: UIImageView!
}

class GameView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let defaults = Defaults()
    let colours = Colours()
    let possibleColours = ["grey","yellow","red","green","blue","orange"]
    var secretCode : Array<String> = []
    var attempts : Int = 0
    let possibleAttempts = 10
    var hints : Array<String> = []
    var allHints : Array<Array<String>> = [[],[],[],[],[],[],[],[],[],[]]
    var playerPlay : Array<String> = []
    var allPlayerPlays : Array<Array<String>> = [[],[],[],[],[],[],[],[],[],[]]
    var gameState : Bool = false
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tHeight = tableView.frame.height
        let temp = tHeight / CGFloat(10)
        return temp > 50.0 ? temp : 50.0
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       //if table view is the game table always be one in front so that table can be responsive
       //else if its pegs table always be on the attempt so that response to the play comes after the play
       if(tableView == gameTable){
           if(attempts < 10) {
               return attempts + 1
           }else{
               return 10
           }
       }else{
           return attempts
       }
       
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if table view is the game table
        //else is the hints table
        if(tableView == gameTable){
            //use cell as a custom gametableview cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameTableViewCell
            //reverse the cell from bottom to top
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.contentView.backgroundColor = UIColor.darkGray
            
            let play = allPlayerPlays[indexPath.row]
            //if play has color then allow to show it instead show nil
            //these ifs allow for a more responsive ui
            if(play.count > 0){
                cell.color1.image = colours.getImageFromColour(colour: play[0])
            }else{
                cell.color1.image = nil
            }
            if(play.count > 1){
                cell.color2.image = colours.getImageFromColour(colour: play[1])
            }else{
                cell.color2.image = nil
            }
            if(play.count > 2){
                cell.color3.image = colours.getImageFromColour(colour: play[2])
            }else{
                cell.color3.image = nil
            }
            if(play.count > 3){
                cell.color4.image = colours.getImageFromColour(colour: play[3])
            }else{
                cell.color4.image = nil
            }
            return cell
        }
        
        if(tableView == resultsTable){
            //use cell as a custom hintstableview cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "hintsCell", for: indexPath) as! HintsTableViewCell
            //reverse the cell from bottom to top
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.contentView.backgroundColor = UIColor.darkGray
            let hint = allHints[indexPath.row]
            //if hints has pegs then allow to show it instead show nil
            //these ifs allow for a more responsive ui
            if(hint.count > 0){
                cell.hint1.image = colours.getImageFromColour(colour: hint[0])
            }else{
                cell.hint1.image = nil
            }
            if(hint.count > 1){
                cell.hint2.image = colours.getImageFromColour(colour: hint[1])
            }else{
                cell.hint2.image = nil
            }
            if(hint.count > 2){
                cell.hint3.image = colours.getImageFromColour(colour: hint[2])
            }else{
                cell.hint3.image = nil
            }
            if(hint.count > 3){
                cell.hint4.image = colours.getImageFromColour(colour: hint[3])
            }else{
                cell.hint4.image = nil
            }
            return cell
        }
        return UITableViewCell()
    }
    
    //check if player lost if yes update game results
    private func checkIfLost() -> Bool {
        //if attempts equals 10 and the game state equals false means player lost
        if(attempts == possibleAttempts && !gameState){
            updateResults(winner: "ai", end: false, attempts: attempts)
            return true
        }
        return false
    }
    
    //check if player won if yes update game results
    private func checkIfWon() -> Bool {
        //if pegs does not contain white and count is 4 means player wins
        if(!hints.contains("white") && hints.count == 4){
            gameState = true
            updateResults(winner: "user", end: true, attempts: attempts)
            return true
        }
        return false
    }
    
    //update game results
    private func updateResults(winner : String, end: Bool, attempts: Int){
        //add win to the memory
        defaults.addWin(winner: winner)
        //create a results object with the data from the game and add to the latest results
        let gameResult = Results(winOrLoss: end, attempts: attempts, colors: secretCode)
        defaults.addLatestResult(result: gameResult)
        
    }
    
    //check if user play has the same colour in the same place or not
    private func returnPegs(play : Array<String>){
        hints = []
        for i in 0..<secretCode.count{
            if(secretCode[i] == play[i]){
                hints.append("black")
            }
        }
        for a in 0..<secretCode.count{
            if(secretCode[a] == play[a]){
                continue
            }
            for j in 0..<play.count{
                if(secretCode[a] == play[j]){
                    hints.append("white")
                }
            }
        }
        hints = hints.sorted()
        allHints[attempts] = hints
    }
    
    //create a random code to be used on the game
    private func createRandomCode() -> Array<String>{
        //choose 4 colors at random from the possible colours
        for _ in 0...3{
            secretCode.append(possibleColours.randomElement()!)
        }
        return secretCode
    }
    
    //show alert with won or lost message
    private func showAlert(){
        var message : String
        if(gameState){
            message = "You Won"
        }else{
            message = "You Lost"
        }
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)

        //leave view
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: "backToMenu", sender: self)
        }))
        
        //return all variables to original values so player can play again
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { (action: UIAlertAction!) in()
            self.secretCode = []
            self.secretCode = self.createRandomCode()
            print(self.secretCode)
            self.attempts = 0
            self.allHints = [[],[],[],[],[],[],[],[],[],[]]
            self.hints = []
            self.playerPlay = []
            self.allPlayerPlays = [[],[],[],[],[],[],[],[],[],[]]
            self.gameState = false
            self.resultsTable.reloadData()
            self.gameTable.reloadData()
        }))

        present(alert, animated: true, completion: nil)
    }
    
    //when button is color button is clicked add color to the play
    //if it's the 4th time that player chooses check if won or lost
    private func colorChosen(color : String){
        if(playerPlay.count == 3){
            playerPlay.append(color)
            returnPegs(play: playerPlay)
            allPlayerPlays[attempts] = playerPlay
            attempts+=1
            if(checkIfWon()){
                showAlert()
            }
            if(checkIfLost()){
                showAlert()
            }
            resultsTable.reloadData()
            playerPlay = []
        }else{
            playerPlay.append(color)
            allPlayerPlays[attempts] = playerPlay
        }
        gameTable.reloadData()
    }
    
    //method that delets the last color chosen
    private func deleteColor(){
        //if play is empty dont delete anything
        if(playerPlay.count > 0){
            playerPlay.removeLast()
        }
        allPlayerPlays[attempts] = playerPlay
        gameTable.reloadData()
    }
    
    //remove scroll indicator from table views
    //reverse table views so it starts from the bottom
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameTable.showsVerticalScrollIndicator = false
        self.resultsTable.showsVerticalScrollIndicator = false
        self.gameTable.transform = CGAffineTransform(scaleX: 1, y: -1)
        self.resultsTable.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    //invoke method to create secret code
    override func viewDidAppear(_ animated: Bool) {
        secretCode = createRandomCode()
        print(secretCode)
    }
    
    //for each of the buttons of colors invoke the method colorChosen with its specific colour
    //delete in case its the delete button
    @IBAction func btnClicks(_ sender: Any) {
        let btn = sender as! UIButton
        switch btn.tag{
            case 1:
            colorChosen(color: "blue")
            case 2:
            colorChosen(color: "yellow")
            case 3:
            colorChosen(color: "green")
            case 4:
            colorChosen(color: "red")
            case 5:
            colorChosen(color: "grey")
            case 6:
            colorChosen(color: "orange")
            case 7:
            deleteColor()
            default:
                print("color chosen doesn't exist")
            
        }
    }
    
    @IBOutlet weak var gameTable: UITableView!
    @IBOutlet weak var resultsTable: UITableView!
}
