//
//  UserDefault.swift
//  ToDo
//
//  Created by Sagar Ajudiya on 21/06/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T:Codable> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults
    init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key) else {
                return defaultValue
            }
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                return value
            } catch {
                print("Error decoding \(T.self): \(error)")
                return defaultValue
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                userDefaults.set(data, forKey: key)
            } catch {
                print("Error encoding \(T.self): \(error)")
            }
        }
    }
}

private protocol OptionalProtocol {
    func isNil() -> Bool
}

extension Optional: OptionalProtocol {
    func isNil() -> Bool {
        return self == nil
    }
}
