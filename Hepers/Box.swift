//
//  Box.swift
//  PhotoApp
//
//  Created by Shevshelev Lev on 02.05.2022.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> Void
    
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
}
