//
//  main.swift
//  foreseer
//
//  Created by Alex Perathoner on 02/10/2021.
//

import Foundation

let sequence = [2,0,2,0,0,2,0,0,2,0,0,2,0,2,1,2,0,2,0,0,1,2,0,1,2,2,0,1,2,0,0,0,2,2,0,2,0,0,2,0,0,0,0,2,0,0,2,1,0,0,0,2,0,0,2,0,2,2,0,1,2,2,0,0,0,2,1,0,2,0,0,0,0,1,2,2,0,0,2, 0,1,2,0]

let result = foresee(arr: sequence)
print("\n Prevision: \(result)")

func foresee(arr: [Int]) -> [Int:Double] {
    var absoluteResult: [Int:Int] = [:]
    var pastOccurences: [Int] = []
    var currentItem = Array(arr.suffix(from: arr.count-1))
    while(currentItem.count > 0) {
        pastOccurences = findPastOccurences(in: arr, of: currentItem)
        absoluteResult = nextChance(arr: arr, pastOccurences: pastOccurences, elemLength: currentItem.count)
        currentItem = Array(currentItem[1..<currentItem.count])
    }
    return calculateChance(absoluteValues: absoluteResult)
}

func calculateChance(absoluteValues: [Int:Int]) -> [Int:Double] {
    let total = absoluteValues.reduce(0, {$0 + $1.value})
    let unit = 1 / Double(total)
    var result: [Int:Double] = [:]
    for elem in absoluteValues {
        result[elem.key] = Double(elem.value) * unit
    }
    return result
}

func findPastOccurences(in arr: [Int], of elem: [Int]) -> [Int] {
    var currentIndex = 0
    var result: [Int] = []
    while(currentIndex <= arr.count - elem.count - 1) {
        let currentItem = Array(arr[currentIndex..<(currentIndex+elem.count)])
        if(currentItem == elem) {
            result.append(currentIndex)
        }
        currentIndex += 1
    }
    return result
}

func nextChance(arr: [Int], pastOccurences: [Int], elemLength: Int) -> [Int: Int] {
    if(pastOccurences.count == 0) {
        return [:]
    }
    var result: [Int: Int] = [:]
	pastOccurences.forEach { occurence in
        let nextElement = arr[occurence+elemLength]
        if(result[nextElement] != nil) {
            result[nextElement]! += 1
        } else {
            result[nextElement] = 1
        }
	}
    return result
}
