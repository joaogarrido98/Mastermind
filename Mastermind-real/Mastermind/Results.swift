//
//  Results.swift
//  Mastermind
//
//  Created by Garrido, Joao on 27/10/2021.
//

import Foundation

//struct to hold results and insert in defaults in an easier way
struct Results : Codable{
    var winOrLoss : Bool
    var attempts : Int
    var colors : Array<String>
}
