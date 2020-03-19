//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by umam on 3/19/20.
//  Copyright © 2020 umam. All rights reserved.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            self.title ?? "Unknown value"
        }

        set {
            title = newValue
        }
    }

    public var wrappedSubtitle: String {
        get {
            self.subtitle ?? "Unknown value"
        }

        set {
            subtitle = newValue
        }
    }
}
