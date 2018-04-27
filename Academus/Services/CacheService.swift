//
//  CacheService.swift
//  Academus
//
//  Created by Pasha Bouzarjomehri on 4/21/18.
//  Copyright © 2018 Caffeinated Insomniacs. All rights reserved.
//

import Foundation

protocol ImageCacheDelegate {
    func didGetImage(image: UIImage)
}

class CacheService {
    
    var imageCacheDelegate: ImageCacheDelegate?
    
    func getImage(url: URL, completion: @escaping CompletionHandler) {
        if let imagePath = UserDefaults.standard.object(forKey: url.absoluteString) as? String {
            let path = URL(fileURLWithPath: imagePath)
            if let image = read(path) {
                imageCacheDelegate?.didGetImage(image: image)
                completion(true)
            } else {
                retreive(from: url, with: completion)
            }
        } else {
            retreive(from: url, with: completion)
        }
    }
    
    private func save(image: UIImage, with key: String) {
        let imageData = UIImageJPEGRepresentation(image, 1)
        if let imagePath = documentsPath(for: "profile.jpg") {
            do {
                try imageData?.write(to: imagePath, options: .atomic)
                UserDefaults.standard.set(imagePath.path, forKey: key)
                UserDefaults.standard.synchronize()
            } catch let error {
                print(error)
            }
        }
    }
    
    private func read(_ imagePath: URL) -> UIImage? {
        do {
            return try UIImage(data: Data(contentsOf: imagePath))
        } catch let error {
            print(error)
            return nil
        }
    }
    
    private func retreive(from url: URL, with completion: @escaping CompletionHandler) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                self.imageCacheDelegate?.didGetImage(image: image)
                self.save(image: image, with: url.absoluteString)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func documentsPath(for filename: String) -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0]
        
        return URL(fileURLWithPath: path).appendingPathComponent(filename)
    }
}
