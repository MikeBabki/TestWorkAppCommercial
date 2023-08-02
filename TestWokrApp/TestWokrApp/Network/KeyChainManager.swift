//
//  KeyChainManager.swift
//  TestWokrApp
//
//  Created by Макар Тюрморезов on 15.06.2023.
//
import Foundation
import Security

class KeychainManager {
    
    static func saveToken(token: String, service: String) {
        if let data = token.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: "Token",
                kSecValueData as String: data
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Failed to save token to Keychain")
            }
        }
    }
    static func saveEmail(email: String) {
        if let data = email.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "Email",
                kSecValueData as String: data
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Failed to save email to Keychain")
            }
        }
    }
    
    
    static func getEmail() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "Email",
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess, let tokenData = result as? Data {
            return String(data: tokenData, encoding: .utf8)
        } else {
            return nil
        }
    }

    static func getToken(service: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "Token",
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecSuccess, let tokenData = result as? Data {
            return String(data: tokenData, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    static func deleteToken(service: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: "Token"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Failed to delete token from Keychain")
        }
    }
    
    static func deleteEmail() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "Email"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Failed to delete token from Keychain")
        }
    }

}
