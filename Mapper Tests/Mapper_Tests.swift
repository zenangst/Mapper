//
//  Mapper_Tests.swift
//  Mapper Tests
//
//  Created by Christoffer Winterkvist on 01/03/15.
//
//

import UIKit
import XCTest

class Person: NSObject {
    var name: String = ""
    var age: Int = 0
    var children: Array<Person> = []
}

class Mapper_Tests: XCTestCase {
    
    func testFillWithDictionary() {
        let subject = Person.new()
        subject.name = "Bruce Wayne"
        subject.age = 55
        XCTAssertEqual(subject.name, "Bruce Wayne", "Name is Bruce Wayne")
        XCTAssertEqual(subject.age, 55, "Bruce Wayne is 55 years old")
        
        subject.fill(["name":"Batman", "age":0])
        XCTAssertNotEqual(subject.name, "Bruce Wayne", "Name is not Bruce Wayne")
        XCTAssertEqual(subject.name, "Batman", "Name is Batman")
        XCTAssertEqual(subject.age, 0, "Batmans age is unknown")
    }
    
    func testDictionaryRespresentation() {
        let subject = Person.new()
        subject.name = "Bruce Wayne"
        subject.age = 55
        
        let expectedDictionary = ["name":"Bruce Wayne", "age" : 55, "children" : []]
        
        XCTAssertEqual(subject.dictionaryRepresentation(), expectedDictionary, "The dictionaries are the same")
    }
    
}
