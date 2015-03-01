##Mapper

Object mapping made easy

Filling an NSObject with values is as easy as pie.

``` swift
class Person {
    var name: String = ""
    var age: Int = 0
}

let subject = Person.new()
subject.fill(["name":"Batman", "age":55])
```

If you want to get a dictionary representation of your object, we got you covered

``` swift
let objectDictionary: NSDictionary = subject.dictionaryRepresentation()
```

## Contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create pull request
