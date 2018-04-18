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
    var lockPic: UIImageView?
    var lockLabel: UILabel?
    var lockButton: UIButton?
    
    override func viewDidLoad() {
        modalTransitionStyle = .crossDissolve
        
        view.backgroundColor = .clear
        let imageView = UIImageView(image: UIApplication.shared.keyWindow?.rootViewController?.view.blur(blurRadius: 12.0))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(imageView, at: 0)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    func lockApp() {
        guard lockPic == nil else { return }
        guard lockLabel == nil else { return }
        guard lockButton == nil else { return }
        
        let lockImg = UIImage.resizeImage(image: #imageLiteral(resourceName: "lock"), newWidth: 80.0)
        lockPic = UIImageView(image: lockImg)
        lockPic?.tintColor = .navigationsDarkGrey
        lockPic?.alpha = 0.5
        view.addSubview(lockPic!)
        
        lockLabel = UILabel().setUpLabel(text: "Academus is Locked.", font: UIFont.header!, fontColor: .navigationsGreen)
        view.addSubview(lockLabel!)
        
        lockButton = UIButton(type: .roundedRect).setUpButton(title: "Unlock Academus", font: UIFont.standard!, fontColor: .navigationsWhite)
        lockButton?.backgroundColor = .navigationsDarkGrey
        lockButton?.layer.cornerRadius = 10
        lockButton?.clipsToBounds = true
        lockButton?.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        if let mainController = (UIApplication.shared.delegate as! AppDelegate).mainController {
            lockButton?.addTarget(mainController, action: #selector(MainController.localAuth), for: .touchUpInside)
        }
        view.addSubview(lockButton!)
        
        lockPic?.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor, CenterYPad: -60)
        lockLabel?.anchors(top: lockPic?.bottomAnchor, topPad: 30, centerX: view.centerXAnchor)
        lockButton?.anchors(top: lockLabel?.bottomAnchor, topPad: 18, centerX: view.centerXAnchor)
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

extension UIImage {
    static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
