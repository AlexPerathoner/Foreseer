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

func foresee<T>(arr: [T]) -> [T:Double] {
    var absoluteResult: [T:Int] = [:]
    var currentSubArray = Array(arr.suffix(from: arr.count-1))
    while(currentSubArray.count > 0) {
        let indexesOfPastOccurences = findIndexesOfPastOccurences(in: arr, of: currentSubArray)
        absoluteResult = getNextElementOccurences(arr: arr, indexesOfPastOccurences: indexesOfPastOccurences, elemLength: currentSubArray.count)
        currentSubArray = Array(currentSubArray[1..<currentSubArray.count])
    }
    return absoluteToRelativeValues(absoluteValues: absoluteResult)
}

func absoluteToRelativeValues<T>(absoluteValues: [T:Int]) -> [T:Double] {
    let total = absoluteValues.reduce(0, {$0 + $1.value})
    let unit = 1 / Double(total)
    var result: [T:Double] = [:]
    for elem in absoluteValues {
        result[elem.key] = Double(elem.value) * unit
    }
    return result
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
