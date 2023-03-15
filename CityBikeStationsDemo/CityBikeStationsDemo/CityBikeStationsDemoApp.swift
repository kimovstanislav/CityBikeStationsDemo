//
//  CityBikeStationsDemoApp.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 14.03.23.
//

import SwiftUI

@main
struct CityBikeStationsDemoApp: App {
  var body: some Scene {
    WindowGroup {
      StationsNetworkView(viewModel: ViewModelFactory.shared.makeStationsNetworkViewModel())
    }
  }
}
