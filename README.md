# FluxSwift [![Build Status](https://travis-ci.org/malt03/FluxSwift.svg?branch=master)](https://travis-ci.org/malt03/FluxSwift) [![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg)](https://github.com/apple/swift-package-manager) ![License](https://img.shields.io/github/license/malt03/FluxSwift.svg)

FluxSwift is a completly typesafe Flux implementation using RxSwift.  
Unlike Redux, Store is not a singleton.

## Usage

### Store
```swift
struct User: Store {
    let name: String
}
```

### Action
In FluxSwift, unlike normal Flux, a reduce function is defined in Action.  
This provides a type-safe implementation and prevents Fat Store.

```swift
struct ChangeName: Action {
    let newName: String
    func reduce(store: User) -> User? { // If you don't apply the Action to the Store, you can return nil.
        var tmp = store
        tmp.name = newName
        return tmp
    }
}
```

### Register, Subscribe and Dispatch
```Swift
let user: RegisteredStore<User> = User(name: "malt03").register() // register the store to Dispatcher
print(user.entity.name) // "malt03"
let disposable = user.subscribe(onNext: { (user) in print(user.name) }) //
ChangeName(newName: "malt04").run() // dispatch
```

### Define a nested Store
Set the value of childStores, an instance variable that conforms to the Store protocol.  
If implemented as follows, when user is changed, the change will be detected in Session.

```swift
struct Session: Store {
    var token: String
    let user: RegisteredStore<User>

    var childStores: [AnyRegisteredStore] { [user.any()] }
}
```

### IdentifiableStore
By conforming to the IdentifiableStore Protocol, you can apply an Action only to the Store with the specified ID.

```swift
struct IdentifiableCounter: IdentifiableStore {
    let id: String
    var count = 0
    
    struct Increment: Action {
        func reduce(store: IdentifiableCounter) -> IdentifiableCounter? {
            var tmp = store
            tmp.count += 1
            return tmp
        }
    }
}

let a = IdentifiableCounter(id: "a").register()
let b = IdentifiableCounter(id: "b").register()
IdentifiableCounter.Increment().apply(to: "a")
IdentifiableCounter.Increment().apply()
print(a.entity.count) // 2
print(b.entity.count) // 1
```

### Store with Codable
RegisteredStore also complies with Codable when Store conforms to Codable Protocol.

```swift
extension User: Codable {}
let json = try! JSONEncoder().encode(user) // { "name": "malt03" }
print(JSONDecoder().decode(RegisteredStore<User>.self, from: json).entity.name) // "malt03"
```

### ThrowsAction
```swift
struct ChangeName: ThrowsAction {
    let newName: String
    func reduce(store: User) -> User? {
        var tmp = store
        store.name = newName
        return store
    }
}
try ChangeNameFromFile(nameFile: url).run()
```

## Installation

### [SwiftPM](https://github.com/apple/swift-package-manager) (Recommended)

- On Xcode, click `File` > `Swift Packages` > `Add Package Dependency...`
- Input `https://github.com/malt03/FluxSwift.git`
