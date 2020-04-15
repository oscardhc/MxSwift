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
            ret += "\(sep)\(method(self[i]))"
        }
        return ret
    }
}

extension Array {
    func generated<T>(check: (Element) -> T?) -> Array<T> {
        var ret = [T]()
        for i in self {
            if let p = check(i) {
                ret.append(p)
            }
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
        
        var list: List
        var next: Node? = nil
        var prev: Node? = nil
        var value: T! = nil
        
        init(value: T!, in list: List) {
            self.value = value
            self.list = list
            if value != nil {
                list.count += 1
            }
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
            prev!.next = next
            next!.prev = prev
            list.count -= 1
        }
        func moveAppendTo(newlist: List) {
            remove()
            list = newlist
            newlist.append(self)
        }
        var indexBF: Int {
            list.getNodeIndexBF(from: self)
        }
        
    }
    
    class VirtualNode: Node {
        init(in list: List) {
            super.init(value: nil, in: list)
        }
    }
    
    var head: Node!
    var tail: Node!
    
    var count = 0
    var isEmpty: Bool {
        count == 0
    }
    
    var first: T? {return isEmpty ? nil : head.next!.value}
    var last: T? {return isEmpty ? nil : tail.prev!.value}
    
    init() {
        head = VirtualNode(in: self)
        tail = VirtualNode(in: self)
        head.next = tail
        tail.prev = head
    }
    
    func removeAll() {
        head = VirtualNode(in: self)
        tail = VirtualNode(in: self)
        head.next = tail
        tail.prev = head
        count = 0
    }
    
    func node(at index: Int) -> Node {
        var cur = head.next
        for _ in 0..<index {
            cur = cur!.next
        }
        return cur!
    }
    
    func append(_ a: Node) {
        let ret = a.setPrev(prev: tail.prev).setNext(next: tail)
        tail.prev!.setNext(next: ret)
        tail.setPrev(prev: ret)
    }
    func append(_ a: T) -> Node {
        let ret = Node(value: a, in: self)
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
        
        let cur = node(at: index)
        let ret = Node(value: a, in: self)
            .setNext(next: cur)
            .setPrev(prev: cur.prev)
        
        cur.prev?.setNext(next: ret)
        cur.setPrev(prev: ret)
        
        return ret
    }
    
    func findNodeBF(where cmp: ((T) -> Bool)) -> (Node, Int)? {
        var cur = head.next
        var idx = 0
        while cur?.next != nil {
            if cmp(cur!.value) {
                return (cur!, idx)
            }
            cur = cur!.next
            idx += 1
        }
        return nil
    }
    
    func removeNodeBF(where cmp: ((T) -> Bool)) {
        var cur = head.next
        while cur?.next != nil {
            if cmp(cur!.value) {
                cur!.remove()
                return
            }
            cur = cur!.next
        }
    }
    
    func findPrevBF(from: Node, where cmp: ((T) -> Bool)) -> Node? {
        var cur: Node? = from
        while cur?.prev != nil {
            if cmp(cur!.value) {
                return cur!
            }
            cur = cur!.prev
        }
        return nil
    }
    
    func getNodeIndexBF(from: Node) -> Int {
        var cur: Node? = from, ret = 0
        while cur?.prev != nil {
            cur = cur!.prev
            ret += 1
        }
        return ret
    }
    
    func remove(node cur: Node) {
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
