//
//  main.swift
//  foreseer
//
//  Created by Alex Perathoner on 02/10/2021.
//

import Foundation

var sequence = [2,0,2,0,0,2,0,0,2,0,0,2,0,2,1,2,0,2,0,0,1,2,0,1,2,2,0,1,2,0,0,0,2,2,0,2,0,0,2,0,0,0,0,2,0,0,2,1,0,0,0,2,0,0,2,0,2,2,0,1,2,2,0,0,0,2,1,0,2,0,0,0,0,1,2,2,0,0,2, 0,1,2,0,1,2,0,0,0,2]

var result = foresee(arr: sequence, branches: 5)

result.printTree()
let likelyBranch = result.getLikelyBranch()
print(likelyBranch)


class ChancesTreeNode<T: Hashable & LosslessStringConvertible>: Hashable {
    var value: T?
    var chance: Double?
    var children: [ChancesTreeNode] = []
    
    init() {
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
        // TODO: beautify
        for (index, child) in children.enumerated() {
            var str = ""
            if(layer > 1) {
                for _ in 0..<layer {
                    str += " "
                }
            }
            if(layer > 0) {
                if(children.count-1 == index) {
                    str += "┗╸"
                } else {
                    str += "┣╸"
                }                
            }

            print("\(str)\(child.value!) - \(String(format: "%.2f", child.chance!))")
            printChildren(layer: layer+1, children: child.children)
        }
    }

    func printTree() {
        printChildren(layer: 0, children: children)
    }

    func getLikelyBranch() -> [T] {
        getLikelyBranch(tree: self)
    }

    func getLikelyBranch(tree: ChancesTreeNode) -> [T] {
        var path: [T] = []
        var tempTree = tree
        repeat {
            let likely = getLikelyBranch(children: tempTree.children)
            path.append(likely.value!)
            tempTree = likely
        } while(tempTree.children.count > 0)
        return path
    }

    func getLikelyBranch(children: [ChancesTreeNode]) -> ChancesTreeNode {
        var likely = children.first!
        for i in children {
            if(i.chance! > likely.chance!) {
                likely = i
            }
        }
        return likely
    }

}

func foresee<T:Hashable>(arr: [T], branches: Int) -> ChancesTreeNode<T> {
    let root = ChancesTreeNode<T>()
    root.add(foresee(arr: arr).children)
    if(branches > 1) {
        for elem in root.children {
            var newArr = arr
            newArr.append(elem.value!)
            let innerResult = foresee(arr: newArr, branches: branches-1)
            elem.add(innerResult.children)
        }
    }
    return root
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
