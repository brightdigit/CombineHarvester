//
//  CombineHarvesterApp.swift
//  CombineHarvester
//
//  Created by Leo Dion on 2/26/21.
//

import SwiftUI
import CombineHarvesterKit

@main
struct CombineHarvesterApp: App {
    var body: some Scene {
        WindowGroup {
          CHView().environmentObject(CoreLocationObject())
        }
    }
}
