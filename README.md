# CityBikeStationsDemo

Thoughts:
APIClient strictly should be unowned in a ViewModel, because it's stored outside in ViewModelFactory. But in this case the injected MockAPIClient won't be retained. Also ViewModelFactory is a singleton, and the APIClient will stay alive for the whole lifecycle. So it is fine.

Could add a StateMachine to be injected into the ViewModel, and also be separately unit tested. But looks an overkill in the current case. In other case could add more control over the object.

Not sure if making the whole ViewModel a @MainActor would better. But would add trouble for injecting and unit testing it. So tried to be less intrusive, isolating only the exposed properties to the main thread. Could still learn how to use it better.
