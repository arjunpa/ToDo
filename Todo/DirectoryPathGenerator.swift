//
//  DirectoryPathGenerator.swift
//  Todo
//
//  Created by Arjun P A on 25/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

class DirectoryPathGenerator {
    
    enum Directory {
        case document
        case temporary
    }
    
    private var directoryURL: URL
    
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
        if relativePath.hasPrefix("/") {
            relativePath = String(relativePath.dropFirst(1))
        }
        return self.directoryURL.appendingPathComponent(relativePath)
    }
}
