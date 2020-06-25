//
//  DirectoryPathGenerator.swift
//  Todo
//
//  Created by Arjun P A on 25/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

final class DirectoryPathGenerator {
    
    enum Directory {
        case document
        case temporary
    }
    
    private var directoryURL: URL
    
    private let pathComponent = "/"
    
    init(directory: Directory) {
        switch directory {
        case .document:
            self.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        case .temporary:
            self.directoryURL = FileManager.default.temporaryDirectory
        }
    }
    
    func buildPath(for relativePath: String) -> String {
        return self.buildURL(for: relativePath).path
    }
    
    func buildURL(for relativePath: String) -> URL {
        var relativePath = relativePath
        if relativePath.hasPrefix(self.pathComponent) {
            relativePath = String(relativePath.dropFirst(self.pathComponent.count))
        }
        return self.directoryURL.appendingPathComponent(relativePath)
    }
}
