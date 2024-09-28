class Observable<T> {
    private var _value: T {
        didSet {
            listener?(_value)
        }
    }

    var value: T {
        get {
            return _value
        }
        set {
            _value = newValue
        }
    }

    private var listener: ((T) -> Void)?

    init(_ value: T) {
        self._value = value
    }

    func bind(_ listener: @escaping (T) -> Void) {
        self.listener = listener
        listener(_value)
    }

    func first() -> T? {
        return _value
    }

    func dropFirst() -> [T]? {
        guard let arr = _value as? [T], arr.count > 0 else {
            return nil
        }
        return Array(arr[1...])
    }
}

//class Observable<T> {
//    var value: T {
//        didSet {
//            listener?(value)
//        }
//    }
//
//    private var listener: ((T) -> Void)?
//
//    init(_ value: T) {
//        self.value = value
//    }
//
//    func bind(_ listener: @escaping (T) -> Void) {
//        self.listener = listener
//        listener(value)
//    }
//}
//
////class Observable<T> {
////    var value: T {
////        didSet {
////            for observer in observers {
////                observer(value)
////            }
////        }
////    }
////    
//    private var observers: [(T) -> Void] = []
////    
////    init(_ value: T) {
////        self.value = value
////    }
////    
////    func bind(_ observer: @escaping (T) -> Void) {
////        observers.append(observer)
////        observer(value)
////    }
////}
