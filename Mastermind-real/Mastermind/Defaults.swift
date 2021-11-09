//
//  Defaults.swift
//  Mastermind
//
//  Created by Garrido, Joao on 26/10/2021.
//

import Foundation


//custom class to make it easier to handle user defaults
class Defaults{
    //get user memory of latest 10 results
    public func getLastResults() -> [Results] {
        if let data = UserDefaults.standard.data(forKey: "results") {
            let array : [Results] = try! PropertyListDecoder().decode([Results].self, from: data)
            return array
        }
        return []
    }
    
    //add result to user memory
    //in case there are 10 already remove the first one
    public func addLatestResult(result : Results) {
        var resultsArray : [Results] = getLastResults()
        if(!resultsArray.isEmpty && resultsArray.count == 10){
            resultsArray.removeFirst()
        }
        resultsArray.append(result)
        if let data = try? PropertyListEncoder().encode(resultsArray) {
            UserDefaults.standard.set(data, forKey: "results")
        }
    }
    
    //add win to user memory
    public func addWin(winner : String){
        var winArray = getWins()
        winArray.append(winner)
        UserDefaults.standard.set(winArray, forKey: "wins")
    }
    
    //get user memory of wins
    public func getWins() -> Array<String> {
        return UserDefaults.standard.stringArray(forKey: "wins") ?? []
    }
}
