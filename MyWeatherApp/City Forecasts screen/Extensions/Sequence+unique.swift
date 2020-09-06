//
//  Sequence+unique.swift
//  MyWeatherApp
//
//  Created by Ahmed Sultan on 9/6/20.
//  Copyright © 2020 Ahmed Hamza. All rights reserved.
//

import Foundation

//MARK:- Sequence unique
public extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
