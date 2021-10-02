//
//  main.swift
//  foreseer
//
//  Created by Alex Perathoner on 02/10/2021.
//

import Foundation

let sequence = [2,0,2,0,0,2,0,0,2,0,0,2,0,2,1,2,0,2,0,0,1,2,0,1,2,2,0,1,2,0,0,0,2,2,0,2,0,0,2,0,0,0,0,2,0,0,2,1,0,0,0,2,0,0,2,0,2,2,0,1,2,2,0,0,0,2,1,0,2,0,0,0,0,1,2,2,0,0,2,0]
let current = [0,0,2,0]

let result = foresee(arr: sequence, elem: current)
print(result)

func foresee(arr: [Int], elem: [Int]) -> [Int:Double] {
    var result: [Int:Double] = [:]
    var pastOccurences: [Int] = []
    var currentItem = elem
    while(result == [:] && currentItem.count > 0) {
        pastOccurences = findPastOccurences(in: arr, of: currentItem)
        print(pastOccurences, currentItem)
        result = nextChance(arr: arr, pastOccurences: pastOccurences, elemLength: currentItem.count)
        currentItem = Array(currentItem[1..<currentItem.count])
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

func nextChance(arr: [Int], pastOccurences: [Int], elemLength: Int) -> [Int: Double] {
    if(pastOccurences.count == 0) {
        return [:]
    }
    var result: [Int: Double] = [:]
    let unit = 1.0 / Double(pastOccurences.count)
	pastOccurences.forEach { occurence in
        let nextElement = arr[occurence+elemLength]
        if(result[nextElement] != nil) {
            result[nextElement]! += unit
        } else {
            result[nextElement] = unit
        }
	}
    return result
}
