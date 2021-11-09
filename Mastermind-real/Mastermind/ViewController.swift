//
//  ViewController.swift
//  Mastermind
//
//  Created by Garrido, Joao on 26/10/2021.
//

import UIKit

class ViewController: UIViewController {
    
    //lock orientation to portrait only
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

