//
//  DemoConflictsViewController.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/24.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

class DemoConflictsViewController: UIViewController {

    let conflictFile = ConflictSelectionSheetController.Action(title: "Last edited on Shawn's iPhone", subtitle: "12/02/2016 at 18:02", image: #imageLiteral(resourceName: "Template Sample"))
    let conflictFile2 = ConflictSelectionSheetController.Action(title: "Last edited on Shawn's iPad", subtitle: "13/02/2016 at 07:26", image: #imageLiteral(resourceName: "Template Sample"))
    let conflictFile3 = ConflictSelectionSheetController.Action(title: "Last edited on Shawn's iPhone", subtitle: "01/03/2016 at 01:14", image: #imageLiteral(resourceName: "Template Sample"))
    
    @IBOutlet weak var detailButton: UIButton!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    class func create() -> DemoConflictsViewController {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let vc = main.instantiateViewController(withIdentifier: "Conflict") as! DemoConflictsViewController
        return vc
    }
    
    @IBAction func handleButton1Tap(_ sender: UIButton) {
        let conflictFiles = [conflictFile]
        let vc = ConflictSelectionSheetController.create(title: "", message: "", actions: conflictFiles)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func handleButton2Tap(_ sender: UIButton) {
        let conflictFiles = [conflictFile, conflictFile2, conflictFile3]
        let vc = ConflictSelectionSheetController.create(title: "", message: "", actions: conflictFiles)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func handleButton3Tap(_ sender: UIButton) {
        let conflictFiles = [conflictFile, conflictFile3, conflictFile2, conflictFile, conflictFile2, conflictFile3, conflictFile, conflictFile, conflictFile2, conflictFile]
        let vc = ConflictSelectionSheetController.create(title: "", message: "", actions: conflictFiles)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func handleCloseButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
