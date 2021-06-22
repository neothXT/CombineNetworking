# CombineNetworking
Easy approach on Networking using Combine

## Installation (using CocoaPods)

`pod 'CombineNetworking'`

## Usage

### Create an Endpoint to work with
```Swift
enum TodosEndpoint {
  case .todos(Int)
}

extension TodosEndpoint: Endpoint {
  var baseURL: URL? {
    URL(string: "https://jsonplaceholder.typicode.com/")
  }
	
  var path: String {
    switch self {
      case .todos:
      return "todos"
    }
  }
	
  var method: RequestMethod {
    .get
  }
	
  var headers: [String : Any]? {
    nil
  }
	
  var data: EndpointData {
    switch self {
      case .todos(let id):
      return .queryParams(["id": id])
    }
  }
}
```

`RequestMethod` is an enum with following options: `.get`, `.post`, `.put`, `.delete`.
`EndpointData` is also an enum with following options: 
- `.plain`
- `.queryParams([String: Any])`
- `.dataParams([String: Any])` - takes `Dictionary` and parses it into `Data` to send in request's body
- `.jsonModel(Encodable)` - similar to `.dataParams` except this one takes `Encodable` and parses it into `Data` to send in request's body

### Enable SSL and/or Certificate pinning (optional)

```Swift
//First - turn pinning on
CNConfig.pinningModes = [.ssl, .certificate]

//Second - specify certificate names (mandatory for certificate pinning, optional for ssl pinning)
CNConfig.certificateNames = ["MyCert"]

//Third - provide list of acceptable public keys (optional if you've provided certificate names)
CNConfig.SSLKeys = [myKey]
```

Please remember that for `.ssl` option it is required to provide either SSLKey or the name of a certificate attached to the project to resolve SSL public key from.

### Subscribe to a publisher

```Swift
private var subscriptions: Set<AnyCancellable> = []
var todo: Todo?

func subscribeForTodos() {
  CNProvider<TodosEndpoint>().publisher(for: .todos(1))?
    .catch { (error) -> Just<Todo?> in
      print(error)
      return Just(nil)
    }
    .assign(to: \.todo, on: self)
    .store(in: &subscriptions)
}
```

And that's it. Enjoy :)
