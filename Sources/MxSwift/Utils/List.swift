//
//  List.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

class List<T: CustomStringConvertible>: CustomStringConvertible {
    
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
    
    var count = 0
    var isEmpty: Bool {
        return head == nil
    }
    
    var first: T {return head!.value}
    var last: T {return tail!.value}
    
    init() {}
    
    func append(_ a: T) {
        count += 1
        if let t = tail {
            t.next = Node(value: a)
            tail = t.next
        } else {
            head = Node(value: a)
            tail = head
        }
    }
    func remove(node cur: Node<T>) {
        count -= 1
        if let t = cur.next {
            t.prev = cur.prev
        }
        if let q = cur.prev {
            q.next = cur.next
        }
    }
    
    func remove(at index: Int) {
        var cur = head!
        for _ in 0..<index {
            cur = cur.next!
        }
        remove(node: cur)
    }
    
    var description: String {
        return joined()
    }
    
    func forEach(_ f: ((T) -> Void)) {
        var cur = head
        while cur != nil {
            f(cur!.value)
            cur = cur!.next
        }
    }
    func joined(with sep: String = ", ", method: ((T) -> String) = {return "\($0)"}) -> String {
        if head == nil {
            return ""
        }
        var ret = method(head!.value), cur = head?.next
        while cur != nil {
            ret += (sep + method(cur!.value))
            cur = cur!.next
        }
        return ret
    }
    
    subscript(idx: Int) -> T {
        var cur = head
        for _ in 0..<idx {
            cur = cur!.next
        }
        return cur!.value
    }
    
}
