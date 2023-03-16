# CityBikeStationsDemo

Comments:
APIClient strictly should be unowned in a ViewModel, because it's stored outside in ViewModelFactory. But in this case the injected MockAPIClient won't be retained. Also ViewModelFactory and the APIClient will stay alive for the whole app lifecycle. So it is fine.

Could add a StateMachine to be injected into the ViewModel, and also be separately unit tested. But looks an overkill in the current case. In other case could add more control over the object, with strict states, events and side effects.

Not sure if making the whole ViewModel a @MainActor would be better. But would add trouble for injecting and unit testing it. So tried to be less intrusive, isolating only the exposed properties to the main thread. Could still learn how to use it better.

LocationServiceClient is done most basically, just to request a single location. I added safeguards not to leak continuations and not to call resume more than once. But if it will be concurrently called, just the 1st call will return value, others will throw an unknown error. I wrapped it up quickly not to lose more time. Overall, I'd avoid continuations if possible or handle them with extra effort and care if there is no way around.
