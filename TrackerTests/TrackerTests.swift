//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Anastasiia on 18.02.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testViewController() {
        let vc = TrackersViewController()
        assertSnapshots(of: vc, as: [.image])
    }
}
