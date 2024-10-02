import UIKit

class Observable<T> {
    private var _value: T
    private var observers: [ObserverWrapper<T>] = []
    private let queue = DispatchQueue(label: "com.yourapp.observable", attributes: .concurrent)

    var value: T {
        get {
            return queue.sync { _value }
        }
        set {
            queue.async(flags: .barrier) {
                self._value = newValue
                self.notifyObservers()
            }
        }

    }

    init(_ value: T) {
        self._value = value
    }

    func bind(_ observer: @escaping (T) -> Void) {
        let wrapper = ObserverWrapper(observer: observer)
        queue.async(flags: .barrier) {
            self.observers.append(wrapper)
            observer(self._value) // Notify the new observer immediately
        }
    }

    func unbind(_ observer: @escaping (T) -> Void) {
        let wrapper = ObserverWrapper(observer: observer)
        queue.async(flags: .barrier) {
            self.observers.removeAll { $0 === wrapper }
        }
    }

    private func notifyObservers() {
        let observers = self.observers // Copy to avoid mutation during iteration
        let value = self._value
        DispatchQueue.main.async {
            observers.forEach { $0.observer(value) }
        }
    }
}

class ObserverWrapper<T> {
    let observer: (T) -> Void

    init(observer: @escaping (T) -> Void) {
        self.observer = observer
    }
}

