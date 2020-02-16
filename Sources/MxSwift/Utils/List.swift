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

class List<T: CustomStringConvertible>: CustomStringConvertible, Sequence {
    
    func makeIterator() -> List<T>.Iterator {
        return Iterator(current: head.next)
    }
    
    
    struct Iterator: IteratorProtocol {
        
        var current: Node?
        mutating func next() -> T? {
            let e = current?.value
            if current?.next != nil {
                current = current?.next
                return e
            } else {
                return nil
            }
        }
        
    }

        
    class Node {
        
        var next: Node? = nil
        var prev: Node? = nil
        var value: T! = nil
        
        init(value: T!) {
            self.value = value
        }
        @discardableResult func setNext(next: Node?) -> Self {
            self.next = next
            return self
        }
        @discardableResult func setPrev(prev: Node?) -> Self {
            self.prev = prev
            return self
        }
        
        func remove() {
            if let p = prev {
                p.next = next
            }
            if let n = next {
                n.prev = prev
            }
        }
        
    }
    
    class VirtualNode: Node {
        init() {
            super.init(value: nil)
        }
    }
    
    var head: Node = VirtualNode()
    var tail: Node = VirtualNode()
    
    var count = 0
    var isEmpty: Bool {
        return count == 0
    }
    
    var first: T? {return isEmpty ? nil : head.next!.value}
    var last: T? {return isEmpty ? nil : tail.prev!.value}
    
    init() {
        head.next = tail
        tail.prev = head
    }
    
    func nodeAt(index: Int) -> Node {
        var cur = head.next
        for _ in 0..<index {
            cur = cur!.next
        }
        return cur!
    }
    
    func append(_ a: T) -> Node {
        count += 1
        let ret = Node(value: a)
            .setPrev(prev: tail.prev)
            .setNext(next: tail)
        tail.prev!.setNext(next: ret)
        tail.setPrev(prev: ret)
        return ret
    }
    func insert(_ a: T, at index: Int) -> Node {
        if count == 0 {
            return append(a)
        }
        count += 1
        
        let cur = nodeAt(index: index)
        let ret = Node(value: a)
            .setNext(next: cur)
            .setPrev(prev: cur.prev)
        
        cur.setPrev(prev: ret)
        cur.prev?.setNext(next: ret)
        
        return ret
    }
    
    func findNodeBF(val: T, cmp: ((T, T) -> Bool)) -> Node? {
        var cur = head.next
        while cur != nil {
            if cmp(cur!.value, val) {
                return cur
            }
            cur = cur!.next
        }
        return nil
    }
    
    func remove(node cur: Node) {
        count -= 1
        cur.remove()
    }
    
    var description: String {
        return joined()
    }
    
    func joined(with sep: String = ", ", method: ((T) -> String) = {return "\($0)"}) -> String {
        if isEmpty {
            return ""
        }
        var ret = method(head.next!.value), cur = head.next!.next
        while cur?.next != nil {
            ret += (sep + method(cur!.value))
            cur = cur!.next
        }
        return ret
    }
    
    subscript(idx: Int) -> T {
        var cur = head.next
        for _ in 0..<idx {
            cur = cur!.next
        }
        return cur!.value
    }
    
}
