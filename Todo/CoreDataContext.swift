//
//  CoreDataContext.swift
//  Todo
//
//  Created by Arjun P A on 24/06/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataContext {
    
    static let shared: CoreDataContext = {
        let context = CoreDataContext(persistentContainer: NSPersistentContainer(name: "Todo"), store: .onDiskAndMemory)
        return context
    }()
    
    typealias ContextStoreLoadCompletion = (ContextStoreLoadState) -> ()

    enum ContextStoreLoadError: Equatable {
        case loadError
    }

    enum ContextStoreLoadState: Equatable {
        case success
        case failed(ContextStoreLoadError)
        
        static func == (lhs: ContextStoreLoadState, rhs: ContextStoreLoadState) -> Bool {
            switch (lhs, rhs) {
            case (.success, .success):
                return true
            case(.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
    
    enum Store {
        case onDiskAndMemory
        case onMemoryOnly
        
        var description: String {
            switch self {
            case .onDiskAndMemory:
                return NSSQLiteStoreType
            case .onMemoryOnly:
                return NSInMemoryStoreType
            }
        }
    }
    
    private let persistentContainer: NSPersistentContainer
    
    lazy var backgroundContext = self.persistentContainer.newBackgroundContext()
    
    lazy var viewContext = self.persistentContainer.viewContext
    
    private var loadState: ContextStoreLoadState?
    
    var onLoad: ContextStoreLoadCompletion? {
        didSet {
            guard let onLoad = self.onLoad else { return }
            self.invokeOnLoad(onLoad: onLoad)
        }
    }
    
    init(persistentContainer: NSPersistentContainer, store: Store) {
        self.persistentContainer = persistentContainer
        self.load(onCompletion: nil)
        self.configure(container: persistentContainer, with: store)
    }
    
    private func load(onCompletion: ContextStoreLoadCompletion?) {
         self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
             guard let _ = error else {
                 self.loadState = .success
                 self.configureViewContext()
                 onCompletion?(.success)
                 return
             }
             self.loadState = .failed(.loadError)
             onCompletion?(.failed(.loadError))
         })
     }
    
    private func invokeOnLoad(onLoad: @escaping ContextStoreLoadCompletion) {
        switch self.loadState {
        case .success?:
            onLoad(self.loadState ?? .success)
        default:
            self.load(onCompletion: onLoad)
        }
    }
    
    private func configure(container: NSPersistentContainer, with store: Store) {
        let containerDescription = NSPersistentStoreDescription()
        containerDescription.type = store.description
    }
    
    private func configureViewContext() {
        self.viewContext.automaticallyMergesChangesFromParent = true
        self.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
}
