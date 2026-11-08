//
//  UtilitiesTest.swift
//  AmperfyKitTests
//
//  Created by Maximilian Bauer on 09.05.21.
//  Copyright (c) 2021 Maximilian Bauer. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

@testable import AmperfyKit
import XCTest

class UtilitiesTest: XCTestCase {
  func testInt16Valid() {
    XCTAssertTrue(Int16.isValid(value: Int(Int16.max)))
    XCTAssertTrue(Int16.isValid(value: Int(Int16.min)))
    XCTAssertTrue(Int16.isValid(value: Int(0)))
    XCTAssertTrue(Int16.isValid(value: Int(Int16.min) + 1))
    XCTAssertTrue(Int16.isValid(value: Int(Int16.max) - 1))
  }

  func testInt16Invalid() {
    XCTAssertFalse(Int16.isValid(value: Int(Int16.max) + 1))
    XCTAssertFalse(Int16.isValid(value: Int(Int16.min) - 1))
    XCTAssertFalse(Int16.isValid(value: Int(Int32.min)))
    XCTAssertFalse(Int16.isValid(value: Int(Int32.max)))
  }

  func testInt32Valid() {
    XCTAssertTrue(Int32.isValid(value: Int(Int32.max)))
    XCTAssertTrue(Int32.isValid(value: Int(Int32.min)))
    XCTAssertTrue(Int32.isValid(value: Int(0)))
    XCTAssertTrue(Int32.isValid(value: Int(Int32.min + 1)))
    XCTAssertTrue(Int32.isValid(value: Int(Int32.max - 1)))
  }

  func testInt32Invalid() {
    XCTAssertFalse(Int32.isValid(value: Int(Int32.max) + 1))
    XCTAssertFalse(Int32.isValid(value: Int(Int32.min) - 1))
    XCTAssertFalse(Int32.isValid(value: Int(Int64.min)))
    XCTAssertFalse(Int32.isValid(value: Int(Int64.max)))
  }

  func testAsColonDurationString() {
    XCTAssertEqual(0.asColonDurationString, "0:00")
    XCTAssertEqual(5.asColonDurationString, "0:05")
    XCTAssertEqual(59.asColonDurationString, "0:59")
    XCTAssertEqual(60.asColonDurationString, "1:00")
    XCTAssertEqual(65.asColonDurationString, "1:05")
    XCTAssertEqual(3599.asColonDurationString, "59:59")
    XCTAssertEqual(3600.asColonDurationString, "1:00:00")
    XCTAssertEqual(3605.asColonDurationString, "1:00:05")
    XCTAssertEqual(3665.asColonDurationString, "1:01:05")
    XCTAssertEqual(36000.asColonDurationString, "10:00:00")
  }

  func testAsDurationShortString() {
    XCTAssertFalse(0.asDurationShortString.isEmpty)
    XCTAssertFalse(60.asDurationShortString.isEmpty)
    XCTAssertFalse(3660.asDurationShortString.isEmpty)
  }

  func testAsDurationString() {
    XCTAssertFalse(0.asDurationString.isEmpty)
    XCTAssertFalse(65.asDurationString.isEmpty)
    XCTAssertFalse(3665.asDurationString.isEmpty)
  }

  func testAsMinuteString() {
    XCTAssertFalse(0.asMinuteString.isEmpty)
    XCTAssertFalse(120.asMinuteString.isEmpty)
  }

  func testAsDayString() {
    XCTAssertFalse(0.asDayString.isEmpty)
    XCTAssertFalse(86400.asDayString.isEmpty)
  }

  func testAsByteString() {
    XCTAssertFalse(Int64(0).asByteString.isEmpty)
    XCTAssertFalse(Int64(1024).asByteString.isEmpty)
    XCTAssertFalse(Int64(1_048_576).asByteString.isEmpty)
  }

  func testAsIso8601DateAndString() {
    let dateStr = "2021-03-31T18:16:10Z"
    let date = dateStr.asIso8601Date
    XCTAssertNotNil(date)
    XCTAssertEqual(date?.asIso8601String, dateStr)
  }

  func testDateShortFormatters() {
    let date = Date(timeIntervalSince1970: 1617192000) // 2021-03-31 12:00:00 UTC
    XCTAssertFalse(date.asShortDayMonthString.isEmpty)
    XCTAssertFalse(date.asShortHrMinString.isEmpty)
  }
}
