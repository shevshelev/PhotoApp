//
//  Box.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 02.05.2022.
//

import Foundation

protocol BoxProtocol {
    associatedtype Value
    associatedtype Listener
    var listener: Listener? { get }
    var value: Value { get set }
    init(_ value: Value)
    func bind(listener: Listener)
}

final class Box<T>: BoxProtocol {
    typealias Listener = (T) -> Void
    
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    required init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
}
