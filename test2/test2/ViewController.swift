//
//  ViewController.swift
//  test2
//
//  Created by Elaine Chang on 4/2/15.
//  Copyright (c) 2015 Elaine Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 
    @IBOutlet weak var JAN: UIImageView!
    @IBOutlet weak var FEB: UIImageView!
    @IBOutlet weak var MAR: UIImageView!
    @IBOutlet weak var APR: UIImageView!
    @IBOutlet weak var MAY: UIImageView!
    @IBOutlet weak var JUN: UIImageView!
    @IBOutlet weak var JUL: UIImageView!
    @IBOutlet weak var AUG: UIImageView!
    @IBOutlet weak var SEP: UIImageView!
    @IBOutlet weak var OCT: UIImageView!
    @IBOutlet weak var NOV: UIImageView!
    @IBOutlet weak var DEC: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        JAN.image = UIImage(named:"JAN-Y.png")
        FEB.image = UIImage(named:"FEB-Y.png")
        MAR.image = UIImage(named:"MAR-Y.png")
        APR.image = UIImage(named:"APR-Y.png")
        MAY.image = UIImage(named:"MAY-Y.png")
        JUN.image = UIImage(named:"JUN-Y.png")
        JUL.image = UIImage(named:"JUL-Y.png")
        AUG.image = UIImage(named:"AUG-Y.png")
        SEP.image = UIImage(named:"SEP-Y.png")
        OCT.image = UIImage(named:"OCT-Y.png")
        NOV.image = UIImage(named:"NOV-Y.png")
        DEC.image = UIImage(named:"DEC-Y.png")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

