//
//  Colours.swift
//  Mastermind
//
//  Created by Garrido, Joao on 28/10/2021.
//

import Foundation
import UIKit


//A class that allows me to get an image according to a colour
class Colours {
    //dictionary from colour to the correspondent resource
    private let colours : Dictionary<String, UIImage> = [
        "orange" : UIImage(imageLiteralResourceName: "orange"),
        "blue" : UIImage(imageLiteralResourceName: "blue"),
        "red" : UIImage(imageLiteralResourceName: "red"),
        "yellow" : UIImage(imageLiteralResourceName: "yellow"),
        "green" : UIImage(imageLiteralResourceName: "green"),
        "grey" : UIImage(imageLiteralResourceName: "grey"),
        "black" : UIImage(imageLiteralResourceName: "black blob"),
        "white" : UIImage(imageLiteralResourceName: "white blob")
    ]
    //return the image 
    public func getImageFromColour(colour: String) -> UIImage{
        return colours[colour]!
    }
}
