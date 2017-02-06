//
//  ImageResultViewController.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/04.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

class ImageResultViewController: UIViewController {

    @IBOutlet weak var croppedImage: UIImageView!
    
    public var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        croppedImage.image = image

    }
    
    class func create() -> ImageResultViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "cropped") as! ImageResultViewController
        return vc
    }
}
