//
//  LastResultsView.swift
//  Mastermind
//
//  Created by Garrido, Joao on 26/10/2021.
//

import UIKit


//CLASS for custom cell on table view
//holds the link between the labels and the datasource
class ResultsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var colorFour: UIImageView!
    @IBOutlet weak var colorThree: UIImageView!
    @IBOutlet weak var colorTwo: UIImageView!
    @IBOutlet weak var colorOne: UIImageView!
    @IBOutlet weak var winOrLossLabel: UILabel!
    @IBOutlet weak var attemptsLabel: UILabel!
}


class LastResultsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let defaults = Defaults()
    private let coloursClass = Colours()
    private var lastResults : Array<Any> = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastResults.count
    }
    
    //load data from last results into table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath) as! ResultsTableViewCell
        
        //some ui changes to the cells
        cell.contentView.backgroundColor = UIColor.darkGray
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = CGColor.init(red:0 , green:0 , blue:0 , alpha: 0.7)
        
        //get and load results into cell
        let result : Results = lastResults[indexPath.row] as! Results
        if(result.winOrLoss){
            cell.winOrLossLabel.text = "Win"
            //change color to a specific shade of green
            cell.winOrLossLabel.textColor = UIColor(red: 0.28, green: 0.8, blue: 0.26, alpha: 1)
        }else{
            cell.winOrLossLabel.text = "Loss"
            //change color to a specific shade of red
            cell.winOrLossLabel.textColor = UIColor(red: 0.9, green: 0, blue: 0, alpha: 0.8)
        }
        cell.attemptsLabel.text = "Attempts: \(result.attempts)"
        //load the secret code from that game into the images
        cell.colorOne.image = coloursClass.getImageFromColour(colour: result.colors[0])
        cell.colorTwo.image = coloursClass.getImageFromColour(colour: result.colors[1])
        cell.colorThree.image = coloursClass.getImageFromColour(colour: result.colors[2])
        cell.colorFour.image = coloursClass.getImageFromColour(colour: result.colors[3])
        return cell
    }
    
    
    //this function gets the values of win for the user or ai
    // then loads it to the view
    private func loadWins(){
        let winArray : Array<String> = defaults.getWins()
        var userCount : Int = 0
        var aiCount : Int = 0
        
        //loop through the array and count how many of which
        for item in winArray{
            if(item == "user"){
                userCount+=1
            }else{
                aiCount+=1
            }
        }
        phoneLabel.text = "\(aiCount)"
        playerLabel.text = "\(userCount)"
        
    }
  
    //get the latest 10 results of the game
    private func loadResults(){
        lastResults = defaults.getLastResults().reversed()
    }
    
    
    //lock orientation to portrait only
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //remove backgroundcolour from table view
        //and remove scroll indicator
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        loadWins()
        loadResults()
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
}
