//
//  Mapper.swift
//  Mapper
//
//  Created by Christoffer Winterkvist on 01/03/15.
//
//

import Foundation

public extension NSObject {
    
    private func propertyNamesForClass(aClass: AnyClass?) -> NSArray {
        var propertyCount: UInt32 = 0
        let propertyList = class_copyPropertyList(aClass, &propertyCount)
        let properties = NSMutableSet.new()
        
        for (var i: UInt32 = 0; i < propertyCount; i++) {
            let property: objc_property_t = propertyList[Int(i)]
            let propertyName = NSString(UTF8String: property_getName(property))
            
            properties.addObject(propertyName as! String)
        }
        
        return properties.allObjects
    }
    
    private func propertyNames() -> NSArray {
        var reference: AnyClass = self.superclass!
        let properties = NSMutableSet.new()
        
        properties.addObjectsFromArray(propertyNamesForClass(self.classForCoder) as [AnyObject])
        
        while reference.superclass() != nil {
            properties.addObjectsFromArray(propertyNamesForClass(reference) as [AnyObject])
            reference = reference.superclass()!
        }
        
        return properties.allObjects
    }
    
    private func propertyTypesForClass(aClass: AnyClass?) -> Dictionary<String, String> {
        var propertyCount: UInt32 = 0
        let propertyList = class_copyPropertyList(aClass, &propertyCount)
        let propertyTypes = NSMutableDictionary.new()
        let cleanupSet = NSCharacterSet.init(charactersInString: "\"@(){}")

        for (var i: UInt32 = 0; i < propertyCount; i++) {
            let property: objc_property_t = propertyList[Int(i)]
            let propertyName = NSString(UTF8String: property_getName(property))
            let propertyAttributes = NSString(UTF8String: property_getAttributes(property))
            
            var propertyType = NSString(UTF8String: property_copyAttributeValue(property, "T"))
            
            if propertyType?.length > 1 {
                var cleanType: AnyObject = propertyType!.componentsSeparatedByCharactersInSet(cleanupSet)
                propertyType = cleanType.componentsJoinedByString("")
            } else {
                switch propertyType as! String {
                case "B":
                    propertyType = "NSNumber"
                    break
                default:
                    break
                }
            }
            
            propertyTypes["\(propertyName!)"] = "\(propertyType!)"
        }
        
        return propertyTypes.copy() as! Dictionary
    }

    func propertyTypes() -> NSDictionary {
        var reference: AnyClass = self.superclass!
        let mutableDictionary = NSMutableDictionary.new()
        mutableDictionary.addEntriesFromDictionary(propertyTypesForClass(self.classForCoder))
        
        while reference.superclass() != nil {
            mutableDictionary.addEntriesFromDictionary(propertyTypesForClass(reference))
            reference = reference.superclass()!
        }
        
        return mutableDictionary.copy() as! NSDictionary
    }

    class func initWithDictionary(dictionary :NSDictionary) -> Self? {
        return self.init().fill(dictionary)
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        var propertyCount: UInt32 = 0
        var propertyList = class_copyPropertyList(self.classForCoder, &propertyCount)
        var properties: NSMutableDictionary = NSMutableDictionary.new()
        var i: UInt32
        
        for (i = 0; i < propertyCount; i++) {
            let property: objc_property_t = propertyList[Int(i)]
            let propertyName = NSString(UTF8String: property_getName(property))
            let propertyAttribute = NSString(UTF8String: property_getAttributes(property))
            let propertyKey = propertyName as String!
            
            if let propertyValue: AnyObject = self.valueForKey(propertyKey) {
                properties[propertyKey] = propertyValue
            } else {
                properties[propertyKey] = NSNull.new()
            }
        }
        
        return properties.copy() as! NSDictionary
    }
    
    func fill(dictionary: NSDictionary) -> Self? {
        let propertyNames = self.propertyNames()
        let propertyTypes = self.propertyTypes()
        
        for (key, value) in dictionary {
            if propertyNames.containsObject(key),
                let typeString = propertyTypes["\(key)"]! as? String {
                    if typeString == NSStringFromClass(value.classForCoder) ||
                        typeString == "@" {
                        self.setValue(value, forKey: key as! String)
                    }
            }
        }
        
        return self
    }
}