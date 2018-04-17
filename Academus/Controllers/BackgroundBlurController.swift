//
//  BackgroundBlurController.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 4/15/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation
import UIKit

class BackgroundBlurController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .clear
        let imageView = UIImageView(image: UIApplication.shared.keyWindow?.rootViewController?.view.blur(blurRadius: 12.0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(imageView, at: 0)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
}

extension UIView {
    func snapshotView(scale: CGFloat = 0.0, isOpaque: Bool = true) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, isOpaque, scale)
        _ = self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func blur(blurRadius: CGFloat) -> UIImage? {
        guard let blur = CIFilter(name: "CIGaussianBlur") else { return nil }
        
        let image = self.snapshotView(scale: 1.0, isOpaque: true)
        blur.setValue(CIImage(image: image!), forKey: kCIInputImageKey)
        blur.setValue(blurRadius, forKey: kCIInputRadiusKey)
        
        let ciContext  = CIContext(options: nil)
        let result = blur.value(forKey: kCIOutputImageKey) as! CIImage
        let boundingRect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let cgImage = ciContext.createCGImage(result, from: boundingRect)
        
        return UIImage(cgImage: cgImage!)
    }
}
