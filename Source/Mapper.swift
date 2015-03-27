//
//  Mapper.swift
//  Mapper
//
//  Created by Christoffer Winterkvist on 01/03/15.
//
//

import UIKit

extension UIButton {
    func setTitle(title: String) {
        self.setTitle(title, forState: UIControlState.Normal)
    }
}

public extension UIView {

    func fill(object: AnyObject) {
        let UIMapping = [
            "UIButton"    : "title",
            "UILabel"     : "text",
            "UISlider"    : "value",
            "UISwitch"    : "on",
            "UITextField" : "text",
        ]
        let objectDictionary: Dictionary<String, AnyObject> = object.dictionaryRepresentation()
        let interfaceDictionary: Dictionary<String, AnyObject> = self.dictionaryRepresentation()
        let propertyTypes = self.propertyTypes()

        for (key, UIElement) in interfaceDictionary {
            if !UIElement.isKindOfClass(object.classForCoder) &&
               !UIElement.isKindOfClass(NSNull.classForCoder()) {
                for (objectKey, objectValue) in objectDictionary {
                    if key.hasPrefix(objectKey) {
                        if let UIKey = UIMapping[propertyTypes[key] as String] {
                            UIElement.setValue(objectValue, forKey: UIKey)
                        }
                        break
                    }
                }
            }
        }
    }
}

public extension NSObject {

    private func propertyNamesForClass(aClass: AnyClass?) -> NSArray {
        var propertyCount: UInt32 = 0
        let propertyList = class_copyPropertyList(aClass, &propertyCount)
        let properties = NSMutableSet()

        for i in 0..<propertyCount {
            let property: objc_property_t = propertyList[Int(i)]
            let propertyName = NSString(UTF8String: property_getName(property))

            properties.addObject(propertyName as String)
        }

        return properties.allObjects
    }

    private func propertyNames() -> NSArray {
        var reference: AnyClass = self.superclass!
        let properties = NSMutableSet()

        properties.addObjectsFromArray(propertyNamesForClass(self.mirrorClass()!) as [AnyObject])

        while reference.superclass() != nil {
            properties.addObjectsFromArray(propertyNamesForClass(reference) as [AnyObject])
            reference = reference.superclass()!
        }

        return properties.allObjects
    }

    private func propertyTypesForClass(aClass: AnyClass?) -> Dictionary<String, String> {
        var propertyCount: UInt32 = 0
        let propertyList = class_copyPropertyList(aClass, &propertyCount)
        let propertyTypes = NSMutableDictionary()
        let cleanupSet = NSCharacterSet.init(charactersInString: "\"@(){}")

        for i in 0..<propertyCount {
            let property: objc_property_t = propertyList[Int(i)]
            let propertyName = NSString(UTF8String: property_getName(property))
            let propertyAttributes = NSString(UTF8String: property_getAttributes(property))
            var propertyType = NSString(UTF8String: property_copyAttributeValue(property, "T"))

            if self.respondsToSelector(NSSelectorFromString(propertyName as String)) {
                var propertyValue: AnyObject? = self.valueForKey(propertyName as String)

                if propertyType?.length > 1 {
                    var cleanType: AnyObject = propertyType!.componentsSeparatedByCharactersInSet(cleanupSet)
                    propertyType = cleanType.componentsJoinedByString("")
                } else if propertyValue != nil  {
                    propertyType = "\(reflect(propertyValue!).valueType)"
                }

                propertyTypes["\(propertyName!)"] = "\(propertyType!)"
            }
        }

        return propertyTypes.copy() as Dictionary
    }

    public func propertyTypes() -> NSDictionary {
        var aClass: AnyClass = self.mirrorClass()!

        var reference: AnyClass = self.superclass!
        let mutableDictionary = NSMutableDictionary()
        mutableDictionary.addEntriesFromDictionary(propertyTypesForClass(self.mirrorClass()!))

        while reference.superclass() != nil {
            mutableDictionary.addEntriesFromDictionary(propertyTypesForClass(reference))
            reference = reference.superclass()!
        }

        return mutableDictionary.copy() as NSDictionary
    }

    convenience init(dictionary :Dictionary<String, AnyObject>, dateFormat: DateFormat? = .ISO8601) {
        self.init()
        self.fill(dictionary, dateFormat: dateFormat)
    }

    class func initWithDictionary(dictionary :Dictionary<String, AnyObject>, dateFormat: DateFormat? = .ISO8601) -> Self? {
        return self.init().fill(dictionary, dateFormat: dateFormat)
    }

    private func mirrorClass() -> AnyClass? {
        return NSClassFromString(reflect(self).summary)
    }

    public func dictionaryRepresentation() -> Dictionary<String, AnyObject> {
        var aClass: AnyClass = self.classForCoder
        var properties: NSMutableDictionary = NSMutableDictionary()

        if !NSObject.isKindOfClass(aClass) {
            if let craftClass: AnyClass = self.mirrorClass() {
                aClass = craftClass
            }

            var propertyCount: UInt32 = 0
            var propertyList = class_copyPropertyList(aClass, &propertyCount)
            var i: UInt32

            for i in 0..<propertyCount {
                let property: objc_property_t = propertyList[Int(i)]
                let propertyName = NSString(UTF8String: property_getName(property))
                let propertyAttribute = NSString(UTF8String: property_getAttributes(property))
                let propertyKey = propertyName as String!

                if let propertyValue: AnyObject = self.valueForKey(propertyKey) {
                    properties[propertyKey] = propertyValue
                } else {
                    properties[propertyKey] = NSNull()
                }
            }
        }

        return properties.copy() as Dictionary<String, AnyObject>
    }

    public func fill(dictionary: Dictionary<String, AnyObject>, dateFormat: DateFormat? = .ISO8601) -> Self? {
        let propertyNames = self.propertyNames()
        let propertyTypes = self.propertyTypes()

        for (key, value) in dictionary {
            if propertyNames.containsObject(key) {
               if let typeString = propertyTypes["\(key)"]! as? String {
                    if typeString == "\(reflect(value).valueType)" {
                        self.setValue(value, forKey: key)
                    } else if typeString == "NSDate" &&
                        "Swift.String" == "\(reflect(value).valueType)" {
                            var date = NSDate(fromString: value as String, format: dateFormat!)
                            self.setValue(date, forKey: key)
                    }
                }
            }
        }

        return self
    }
}
