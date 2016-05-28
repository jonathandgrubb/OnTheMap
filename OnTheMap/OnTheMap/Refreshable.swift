//
//  Refreshable.swift
//  OnTheMap
//
//  Created by Jonathan Grubb on 5/27/16.
//  Copyright © 2016 Jonathan Grubb. All rights reserved.
//

protocol Refreshable {
    func dataWillRefresh() -> Void
    func dataIsRefreshed() -> Void
}

