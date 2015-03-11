//
//  Mapper_Tests.swift
//  Mapper Tests
//
//  Created by Christoffer Winterkvist on 01/03/15.
//
//

import UIKit
import XCTest

class Interface: UIView {
    var nameLabel: UILabel?
    var infoButton: UIButton?
    var ageSlider: UISlider?
    var heroSwitch: UISwitch?
    var nameTextField: UITextField?
}

class InterfaceModel: NSObject {
    var name  = ""
    var age = 0
    var hero: Bool = false
    var info: String = "some text"
}

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
        
        let expectedDictionary: Dictionary<String,AnyObject> = [
            "name":"Bruce Wayne",
            "age" : 55,
            "children" : [],
            "attributes":[:],
            "archEnemy" : NSNull.new()]

        let userDictionary = subject.dictionaryRepresentation()

        XCTAssertEqual(expectedDictionary as NSDictionary!, userDictionary as NSDictionary!)
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

    func testMappingNSObject() {
        var object = NSObject.new()
        
        XCTAssertEqual(object.dictionaryRepresentation().count, 0)
    }

    func testInterfaceMapping() {
        var ui = Interface.new()
        
        ui.nameLabel = UILabel.new()
        ui.infoButton = UIButton.new()
        ui.ageSlider = UISlider.new()
        ui.ageSlider?.maximumValue = 60.0

        ui.heroSwitch = UISwitch.new()
        ui.nameTextField = UITextField.new()

        var uiModel = InterfaceModel(dictionary: [
            "name" :"Dark Knight",
            "age"  : 55,
            "hero" : true,
            "info": "infoText"
            ])

        XCTAssertNil(ui.nameLabel?.text)
        XCTAssertNil(ui.infoButton?.titleForState(.Application))
        XCTAssertNotNil(ui.ageSlider?.value)
        XCTAssertNotNil(ui.heroSwitch?.on)
        XCTAssertNotNil(ui.nameTextField?.text)

        ui.map(uiModel)

        XCTAssertNotNil(ui.nameLabel?.text!)
        XCTAssertNotNil(ui.infoButton?.titleForState(.Application))
        XCTAssertEqual(ui.ageSlider!.value, 55.0)
        XCTAssertTrue(ui.heroSwitch!.on)
        XCTAssertEqual(ui.nameTextField!.text, "Dark Knight")
    }
    
}


