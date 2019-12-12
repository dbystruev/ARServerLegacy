//
//  Crypto.swift
//  ARServer
//
//  Created by Denis Bystruev on 12.12.2019.
//

import Cryptor

func password(from str: String, salt: String) throws -> String {
    let key = try PBKDF.deriveKey(fromPassword: str, salt: salt, prf: .sha512, rounds: 250_000, derivedKeyLength: 64)
    return CryptoUtils.hexString(from: key)
}
