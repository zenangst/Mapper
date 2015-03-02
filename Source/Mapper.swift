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
        var propertyList = class_copyPropertyList(aClass, &propertyCount)
        var properties: NSMutableSet = NSMutableSet.new()
        var i: UInt32
        
        for (i = 0; i < propertyCount; i++) {
            let property: objc_property_t = propertyList[Int(i)]
            let propertyName = NSString(UTF8String: property_getName(property))
            
            properties.addObject(propertyName as! String)
        }
        
        return properties.allObjects
    }
    
    private func propertyNames() -> NSArray {
        var reference: AnyClass = self.superclass!
        var properties = NSMutableSet.new()
        var resolved = false
        
        properties.addObjectsFromArray(propertyNamesForClass(self.classForCoder) as [AnyObject])
        
        while resolved != true {
            properties.addObjectsFromArray(propertyNamesForClass(reference) as [AnyObject])
            
            if reference.superclass() != nil {
                reference = reference.superclass()!
            } else {
                resolved = true
            }
        }
        
        return properties.allObjects
    }

    class func initWithDictionary(dictionary :NSDictionary) -> Self? {
        var instance = self.init()
        instance.fill(dictionary)
        
        return instance
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
            let propertyValue :AnyObject = self.valueForKey(propertyKey)!
            
            properties[propertyKey] = propertyValue
        }
        
        return properties.copy() as! NSDictionary
    }
    
    func fill(dictionary: NSDictionary) {
        let propertyNames: NSArray = self.propertyNames()
        
        for (key, value) in dictionary {
            if (propertyNames.containsObject(key)) {
                self.setValue(value, forKey: key as! String)
            }
        }
    }
}