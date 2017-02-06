//
//  ComingSoonViewController.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/24.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

class ComingSoonViewController: UIViewController {

    @IBOutlet weak var fadedView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fadedView.layer.cornerRadius = 16
        fadedView.clipsToBounds = true

    }
    
    class func create() -> ComingSoonViewController {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let vc = main.instantiateViewController(withIdentifier: "ComingSoon") as! ComingSoonViewController
        return vc
    }
    
    @IBAction func handleDismissTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
