//
//  List.swift
//  MxSwift
//
//  Created by Haichen Dong on 2020/2/5.
//

import Foundation

extension Array where Element: CustomStringConvertible {
    
    func joined(with sep: String = ", ", method: ((Element) -> String) = {return "\($0)"}) -> String {
        if self.count == 0 {
            return ""
        }
        var ret = method(self[0])
        for i in 1..<self.count {
            ret += "\(sep)\(self[i])"
        }
        return ret
    }
    
}

class List<T: CustomStringConvertible>: CustomStringConvertible {
    
    class Node {
        
        var next: Node? = nil
        var prev: Node? = nil
        var value: T
        
        init(value: T) {
            self.value = value
        }
        func setNext(next: Node) -> Self {
            self.next = next
            return self
        }
        func setPrev(prev: Node) -> Self {
            self.prev = prev
            return self
        }
        
    }
    
    private var head: Node? = nil
    private var tail: Node? = nil
    
    var count = 0
    var isEmpty: Bool {
        return head == nil
    }
    
    var first: T {return head!.value}
    var last: T {return tail!.value}
    
    init() {}
    
    func append(_ a: T) -> Node {
        count += 1
        let ret = Node(value: a)
        if let t = tail {
            t.next = ret.setPrev(prev: t)
            tail = t.next
        } else {
            head = ret
            tail = head
        }
        return ret
    }
    func insert(_ a: T, at index: Int) -> Node {
        count += 1
        let ret = Node(value: a)
        
        var cur = head!
        for _ in 0..<index {
            cur = cur.next!
        }
        if let t = cur.prev {
            cur.prev = ret
            t.next = ret
            ret.prev = t
            ret.next = cur
        }
        
        return ret
    }
    
    func remove(node cur: Node) {
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
