//
//  HomeViewController.swift
//  CSE335-class-project
//
//  Created by Jake Anderson on 11/13/18.
//  Copyright © 2018 Jake Anderson. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var start_book_list_button: UIButton!
    @IBOutlet weak var find_store_button: UIButton!
    @IBOutlet weak var nav_item: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        start_book_list_button.layer.cornerRadius = 10;
        find_store_button.layer.cornerRadius = 10;
    }

}

