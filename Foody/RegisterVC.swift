//
//  RegisterVC.swift
//  Foody
//
//  Created by Sebastian Strus on 2017-12-12.
//  Copyright © 2017 Sebastian Strus. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "registerToWelcome", sender: nil)}

    }
    


