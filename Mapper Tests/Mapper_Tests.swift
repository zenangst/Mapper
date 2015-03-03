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
    var name  = ""
    var age = 0
    var children = []
    var attributes :NSDictionary = [:]
    var archEnemy: AnyObject?
}

class Criminal: Person {
    var nickname: String = ""
    var lastSentencing = NSDate(timeIntervalSince1970: 1)
}

class MasterCriminal: Criminal {
    var myth: Bool = false
}

class Mapper_Tests: XCTestCase {
    
    func testInitWithDictionary() {
        let subject = Person.initWithDictionary(["name":"Alfred","age":70])!
        XCTAssertEqual(subject.age, 70, "Age is 70")
        XCTAssertEqual(subject.name, "Alfred", "Name is Alfred")
    }
    
    func testDeepInheritance() {
        let subject = MasterCriminal.new();
        subject.fill(["nickname" : "Ra's al Ghul", "myth" : true, "name" : "???"])
        XCTAssertTrue(subject.myth, "Subject is a myth")
        XCTAssertEqual(subject.name, "???", "Name is unknown")
        XCTAssertEqual(subject.nickname, "Ra's al Ghul", "Nickname is \"Ra's al Ghul\"")
    }
    
    func testInheritance() {
        let subject = Criminal.initWithDictionary(["nickname" : "The Joker", "age" : 45])!;
        XCTAssertEqual(subject.age, 45, "Age should be 45")
    }
    
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
        
        let archEnemy = MasterCriminal.new()
        
        let expectedDictionary = [
            "name":"Bruce Wayne",
            "age" : 55,
            "children" : [],
            "attributes":[:],
            "archEnemy" : NSNull.new()]
        
        XCTAssertEqual(subject.dictionaryRepresentation(), expectedDictionary, "The dictionaries are the same")
    }

    func testPropertyTypes() {
        var joker = Criminal.initWithDictionary([
            "name":"???",
            "nickname":"The Joker",
            "lastSentencing": "2015-03-03 09:02:25 +0000"])
        var batman = Person.initWithDictionary([
            "name":"Bruce Wayne",
            "age" : 55,
            "children" : [],
            "attributes":[:],
            "archEnemy" : NSNull.new()])!
        
        batman.archEnemy = joker
        
        let propertyTypes = batman.propertyTypes()
        
        XCTAssertEqual(propertyTypes["name"] as! String, "Swift.String")
        XCTAssertEqual(propertyTypes["age"] as! String, "__NSCFNumber")
        XCTAssertEqual(propertyTypes["children"] as! String, "NSArray")
        XCTAssertEqual(propertyTypes["attributes"] as! String, "NSDictionary")
        XCTAssertEqual(propertyTypes["archEnemy"] as! String, "Mapper_Tests.Criminal")
    }
    
    func testTypeSafety() {
        var batman = Person.initWithDictionary([
            "name":"Bruce Wayne",
            "age" : 55,
            "children" : [],
            "attributes":[:],
            "archEnemy" : NSNull.new()])!
        
        batman.fill(["name":[]])
    }
    
}


