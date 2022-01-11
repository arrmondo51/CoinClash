//
//  FileManager+clearTmpDirectory.swift
//  CoinClash
//
//  Created by Mark Lagae on 6/9/17.
//  Copyright © 2017 Mark Lagae. All rights reserved.
//

import Foundation

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}
