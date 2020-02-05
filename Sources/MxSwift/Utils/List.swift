//
//  List.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class List<T> {
    
    class Node<T> {
        
        var next: Node<T>?
        var prev: Node<T>?
        var value: T
        
        init(value: T) {
            self.value = value
        }
        
    }
    
    private var head: Node<T>? = nil
    private var tail: Node<T>? = nil
    
    var isEmpty: Bool {
        return head == nil
    }
    
    init(from a: [T]) {
        
    }
    
    func append(a: T) {
        if let t = tail {
            t.next = Node(value: a)
            tail = t.next
        } else {
            head = Node(value: a)
            tail = head
        }
    }
    
    func remove(at index: Int) {
        var cur = head!
        for _ in 0..<index {
            cur = cur.next!
        }
        if let t = cur.next {
            t.prev = cur.prev
            if let q = cur.prev {
                q.next = t
            }
        }
    }
    
    func remove(node: Node<T>) {
        
    }
    
}
