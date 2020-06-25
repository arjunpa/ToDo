//
//  ImagePickHandler.swift
//  Todo
//
//  Created by Arjun P A on 25/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import UIKit

class ImagePickHandler {
    
    private enum Errors: Error {
        case noDirectoryFound
    }
    
    private let imageDirectoryName = "images"
    
    private var imagePath: String {
        return "/" + self.imageDirectoryName + "/" + UUID().uuidString
    }
    
    let quality: CGFloat
    
    private let pathGenerator: DirectoryPathGenerator
    
    init(pathGenerator: DirectoryPathGenerator, quality: CGFloat) {
        self.quality = quality
        self.pathGenerator = pathGenerator
    }
    
    func handleImage(from info: Any, completion: (Result<String, Error>) -> ()) {
        guard let info = info as? [UIImagePickerController.InfoKey : Any],
              let originalImage = info[.originalImage] as? UIImage
              else { return }
        
        do {
            try self.checkAndCreateDirectoryIfRequired()
            let imagePath = self.imagePath
            let url = self.pathGenerator.buildURL(for: imagePath)
            try originalImage.jpegData(compressionQuality: 0.8)?.write(to: url)
            completion(.success(imagePath))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    private func checkAndCreateDirectoryIfRequired() throws {
        
        let directoryURL = self.pathGenerator.buildURL(for: self.imageDirectoryName)
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: directoryURL.path, isDirectory: &isDirectory) {
            guard !isDirectory.boolValue else { return }
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } else {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
