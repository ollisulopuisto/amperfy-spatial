//
//  AuthParserDelegate.swift
//  AmperfyKit
//
//  Created by Maximilian Bauer on 09.03.19.
//  Copyright (c) 2019 Maximilian Bauer. All rights reserved.
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

import CoreData
import Foundation
import UIKit

class AuthParserDelegate: AmpacheXmlParser {
  var authHandshake: AuthentificationHandshake?
  var serverApiVersion: String?
  private var authBuffer = AuthentificationHandshake()
  private let safetyOffsetTimeBeforeSessionExpireInMinutes: TimeInterval = -5.0 * 60.0

  /// Reusable ISO8601DateFormatter to avoid repeated allocation during auth parsing
  private let iso8601DateFormatter: ISO8601DateFormatter = .init()

  override func parser(
    _ parser: XMLParser,
    didEndElement elementName: String,
    namespaceURI: String?,
    qualifiedName qName: String?
  ) {
    switch elementName {
    case "auth":
      authBuffer.token = buffer
    case "api":
      serverApiVersion = buffer
    case "session_expire":
      authBuffer.sessionExpire = iso8601DateFormatter.date(from: buffer) ?? Date()
      authBuffer.reauthenicateTime = Date(
        timeInterval: safetyOffsetTimeBeforeSessionExpireInMinutes,
        since: authBuffer.sessionExpire
      )
    case "update":
      authBuffer.libraryChangeDates.dateOfLastUpdate = iso8601DateFormatter
        .date(from: buffer) ?? Date()
    case "add":
      authBuffer.libraryChangeDates.dateOfLastAdd = iso8601DateFormatter
        .date(from: buffer) ?? Date()
    case "clean":
      authBuffer.libraryChangeDates.dateOfLastClean = iso8601DateFormatter
        .date(from: buffer) ?? Date()
    case "songs":
      authBuffer.songCount = Int(buffer) ?? 0
    case "artists":
      authBuffer.artistCount = Int(buffer) ?? 0
    case "albums":
      authBuffer.albumCount = Int(buffer) ?? 0
    case "genres":
      authBuffer.genreCount = Int(buffer) ?? 0
    case "playlists":
      authBuffer.playlistCount = Int(buffer) ?? 0
    case "podcasts":
      authBuffer.podcastCount = Int(buffer) ?? 0
    case "videos":
      authBuffer.videoCount = Int(buffer) ?? 0
    case "root":
      authHandshake = (!authBuffer.token.isEmpty ? authBuffer : nil)
    default:
      break
    }

    super.parser(
      parser,
      didEndElement: elementName,
      namespaceURI: namespaceURI,
      qualifiedName: qName
    )
  }
}
