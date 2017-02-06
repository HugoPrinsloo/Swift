//
//  CropperViewController.swift
//  The App
//
//  Created by Hugo Prinsloo on 2017/01/04.
//  Copyright © 2017 Hugo Prinsloo. All rights reserved.
//

import UIKit

class CropperViewController: UIViewController {

    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var cropButton: UIButton!
    @IBOutlet weak var croppedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cropButton.layer.cornerRadius = 8
        cropButton.clipsToBounds = true
        
        //Adding swipe gesture recognizer
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDragging))
        cropView.addGestureRecognizer(gestureRecognizer)
    }
    
    class func create() -> CropperViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "cropper") as! CropperViewController
        return vc
    }
    
    @IBAction func handleCropButtonTap(_ sender: Any) {
        let newFrame = view.convert(cropView.frame, to: photoView)

        print("New frame \(newFrame)")
        
        let vc = ImageResultViewController.create()
        let imageRef:CGImage = photoView.image!.cgImage!.cropping(to: CGRect(x: 0, y: 0, width: 1000, height: 1000))!
        let croppedImage:UIImage = UIImage(cgImage: imageRef)

        vc.image = croppedImage
        
        
        navigationController?.pushViewController(vc, animated: false)
    }
    
    //Moves the view to touchDrag position
    func handleDragging(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
}

extension UIImage {
    
    /// Crop image from self
    ///
    /// Usage:
    ///
    ///  var img = image.getImageInRect(CGRectMake(50,50,150,150))
    
    func getImageInRect(_ rect: CGRect) -> UIImage {
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        // Sets the clipping path to the intersection of the current clipping path with the area defined by the specified rectangle.
        context?.clip(to: CGRect(origin: CGPoint.zero, size: rect.size))
        
        draw(in: CGRect(origin: CGPoint(x: -rect.origin.x, y: -rect.origin.y), size: size))
        
        // Returns an image based on the contents of the current bitmap-based graphics context.
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
}



