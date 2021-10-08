//
//  main.swift
//  foreseer
//
//  Created by Alex Perathoner on 02/10/2021.
//

import Foundation

var sequence = [2,0,2,0,0,2,0,0,2,0,0,2,0,2,1,2,0,2,0,0,1,2,0,1,2,2,0,1,2,0,0,0,2,2,0,2,0,0,2,0,0,0,0,2,0,0,2,1,0,0,0,2,0,0,2,0,2,2,0,1,2,2,0,0,0,2,1,0,2,0,0,0,0,1,2,2,0,0,2, 0,1,2,0]

var result = foresee(arr: sequence)

result.printTree()


class ChancesTreeNode<T: Hashable & LosslessStringConvertible>: Hashable {
    var isRoot = false
    var value: T?
    var chance: Double?
    var children: [ChancesTreeNode] = []
    
    init() {
        isRoot = true
    }

    init(_ value: T, _ chance: Double) {
        self.value = value
        self.chance = chance
    }

    func add(_ child: ChancesTreeNode) {
        children.append(child)
    }
    func add(_ children: [ChancesTreeNode]) {
        self.children.append(contentsOf: children)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(children)
    }

    static func ==(lhs: ChancesTreeNode, rhs: ChancesTreeNode) -> Bool {
        return lhs.value == rhs.value && lhs.chance == rhs.chance
    }

    func printChildren(layer: Int, children: [ChancesTreeNode]) {
        for child in children {
            var str = ""
            for _ in 0..<layer {
                str += "  "
            }
            print("\(str)\(child.value!) - \(child.chance!)")
            printChildren(layer: layer+1, children: child.children)
        }
    }

    func printTree() {
        if(!isRoot) {
            print("\(value!) - \(chance!)")
        }
        printChildren(layer: 0, children: children)
    }

}

func foresee<T>(arr: [T]) -> ChancesTreeNode<T> {
    var absoluteResult: [T:Int] = [:]
    var currentSubArray = Array(arr.suffix(from: arr.count-1))
    while(currentSubArray.count > 0) {
        let indexesOfPastOccurences = findIndexesOfPastOccurences(in: arr, of: currentSubArray)
        absoluteResult = getNextElementOccurences(arr: arr, indexesOfPastOccurences: indexesOfPastOccurences, elemLength: currentSubArray.count)
        currentSubArray = Array(currentSubArray[1..<currentSubArray.count])
    }
    return absoluteToRelativeValues(absoluteValues: absoluteResult)
}

func absoluteToRelativeValues<T>(absoluteValues: [T:Int]) -> ChancesTreeNode<T> {
    let total = absoluteValues.reduce(0, {$0 + $1.value})
    let unit = 1 / Double(total)
    let root = ChancesTreeNode<T>()
    for elem in absoluteValues {
        root.add(ChancesTreeNode(elem.key, Double(elem.value) * unit))
    }
    return root
}

func findIndexesOfPastOccurences<T: Equatable>(in arr: [T], of elem: [T]) -> [Int] {
    var currentIndex = 0
    var result: [Int] = []
    while(currentIndex <= arr.count - elem.count - 1) {
        let currentSubArray = Array(arr[currentIndex..<(currentIndex+elem.count)])
        if(currentSubArray == elem) {
            result.append(currentIndex)
        }
        currentIndex += 1
    }
    return result
}

func getNextElementOccurences<T>(arr: [T], indexesOfPastOccurences: [Int], elemLength: Int) -> [T:Int] {
    if(indexesOfPastOccurences.count == 0) {
        return [:]
    }
    var result: [T:Int] = [:]
	indexesOfPastOccurences.forEach { occurence in
        let nextElement = arr[occurence+elemLength]
        if(result[nextElement] != nil) {
            result[nextElement]! += 1
        } else {
            result[nextElement] = 1
        }
	}
    return result
}
