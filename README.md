##Mapper
[![Build Status](https://img.shields.io/travis/zenangst/Mapper.svg?style=flat)](https://travis-ci.org/zenangst/Mapper)

Object mapping made easy

``` swift

class Person {
    var name: String = ""
    var age: Int = 0
}

let subject = Person.new()
subject.fill(["name":"Batman", "age":0])
```

## Contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create pull request
