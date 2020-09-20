//
//  AsynchronousOperation.swift
//  ProperWayToDownloadAnImage
//
//  Created by Kirill Pustovalov on 19.09.2020.
//

import Foundation

class AsynchronousOperation: Operation {
    enum State: String {
        case ready
        case executing
        case finished
        
        var key: String { "is\(rawValue.capitalized)" }
    }
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.key)
            willChangeValue(forKey: state.key)
        } didSet {
            didChangeValue(forKey: oldValue.key)
            didChangeValue(forKey: state.key)
        }
    }
    final override public var isAsynchronous: Bool { true }
    override public var isReady: Bool { super.isReady && state == .ready }
    override public var isExecuting: Bool { state == .executing }
    override public var isFinished: Bool { state == .finished }
    
    override func cancel() { state = .finished }
    final override func start() {
        guard !isCancelled else {
            state = .finished
            return
        }
        
        main()
        state = .executing
    }
}
