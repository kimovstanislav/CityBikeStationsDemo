# CityBikeStationsDemo

A demo app that extracts bike stations in Vienna and sorts them either by name or by distance, if the location permission is granted.


Remarks:

APIClient strictly should be unowned in a ViewModel, because it's stored outside, in ViewModelFactory. But in this case the injected MockAPIClient won't be retained. Also ViewModelFactory and the APIClient will stay alive for the whole app lifecycle. So it is fine, but may meditate more on it later.

Didn't make the whole ViewModel @MainActor here. Would add some trouble injecting and unit testing it. So tried to be less intrusive, isolating only the exposed properties to the main thread.