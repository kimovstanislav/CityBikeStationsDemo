//
//  StationsNetworkView.swift
//  CityBikeStationsDemo
//
//  Created by Stanislav Kimov on 15.03.23.
//

import Foundation
import SwiftUI

struct StationsNetworkView: View {
  @ObservedObject var viewModel:  StationsNetworkViewModel
    
  var body: some View {
    Group {
      switch viewModel.viewState {
      case .idle:
        placeholderView()
        
      case .loading:
        loaderView()
        
      case .showStations(let stations):
        if stations.count > 0 {
          showStationsList(stations: stations)
        } else {
          emptyListView()
        }

      case .showError(let errorMessage):
        errorView(errorMessage: errorMessage)
      }
    }
    .task {
      viewModel.loadNetworkStations()
    }
    .alert(isPresented: $viewModel.alertModel.showAlert, content: { () -> Alert in
        Alert(
          title: Text(viewModel.alertModel.title),
          message: Text(viewModel.alertModel.message),
          dismissButton: .default(Text(Strings.Button.close)))
    })
  }
  
  // MARK: - Placeholder
  private func placeholderView() -> some View {
    Text("Hallo")
  }
  
  // MARK: - Loading
  private func loaderView() -> some View {
    ProgressView()
  }
  
  // MARK: - Empty list
  private func emptyListView() -> some View {
    Text(Strings.Screen.StationsList.noStations)
  }
  
  // MARK: - Stations list
  private func showStationsList(stations: [Station]) -> some View {
    List(stations) { station in
      Link(destination: viewModel.stationMapUrlFor(station)) {
        listRow(station: station)
      }
      .foregroundColor(.black)
    }
    .refreshable {
      viewModel.loadNetworkStations()
    }
  }
  
  private func listRow(station: Station) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(station.name)
        .font(Font.title)
      Text(String(format: Strings.Screen.StationsList.bikesAvailable, station.freeBikes))
        .font(Font.body)
      Text(String(format: Strings.Screen.StationsList.emptySlotsAvailable, station.emptySlots ?? 0))
        .font(Font.body)
    }
  }
  
  // MARK: - Error
  private func errorView(errorMessage: String) -> some View {
    VStack(alignment: .center) {
      Spacer()
      Text(errorMessage)
        .font(.headline.bold())
        .multilineTextAlignment(.center)
      Button(Strings.Button.retry) {
        viewModel.loadNetworkStations()
      }
      Spacer()
    }
    .padding()
  }
}

struct StationsNetworkView_Previews: PreviewProvider {
    static var previews: some View {
      StationsNetworkView(viewModel: MockViewModelFactory.shared.makeStationsNetworkViewModel())
    }
}


