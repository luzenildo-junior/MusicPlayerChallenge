# Moises Music Player Challenge

## Description
Moises Challenge app for [Moises.ai](https://moises.ai/) Senior iOS Developer position
The idea of this challenge is to use the Moises app design system to implement a music player app. Above you can see the [Figma design](https://www.figma.com/file/J3OI71K2nlJlJZuk6VNXf4/Challenge?type=design&node-id=0-1&mode=design&t=V4EEx4FZwDv28hu4-0) for reference.

## Installation
### System Requirements
This implementation was made on a M1 Mac using `Xcode 13.4.1` running on `MacOS Monterey 12.5`. Unfortunately I didn't had time to update my mac or to use a newer version of the Xcode. But you should be able to open this project on a newer Xcode with no problem. If not, just install `Xcode 13.4.1` and open it.

To be able properly open `MusicPlayerChallenge.xcworkspace`, you should first:
```
pod install
```
If something goes wrong just do a `pod deintegrate` and then `pod install` again.

## About Implementation
### Networking
For this project I decided to make a little Service Networking API implementation, that pretty much uses URLSession along with Combine to make API calls. To configure the service, I'm using an `APIRequest` Protocol to handle the path, method and parameters configuration for service requests. That Protocol also conforms with `URLRequestConvertible` so it can be used with no problem with the DataTask `dataTaskPublisher`. The response for the API calls is a Combine Future Promise that will be handled in the Session layer of the networking API. For that I created the `MusicPlayerSession` interface to expose the two requests we have in this implementation to the Service side of the main app architecture.

### Architecture
As a recommendation I used MVVM-C in this assignment. I decided to use `Combine` to handle the communication between `ViewModel -> ViewController`, and also decided to use `Closures` to handle the communication between `ViewModel -> Coordinator`. As Apple is slowly moving away from Delegates, I decided not to have any Delegate implemented in this project (besides of course the `UITableViewDelegate`)
For the `View` implementation, I used one of my favorite kind of view implementation which is hard coding everything using Swift and UIKit. 

#### Coordinators
Personally, I have what I can call "a love affair" with `Coordinators`. I learned about them 6 years ago, and for me it is still the best way to handle navigation flows in iOS Swift applications. In this implementation, each feature has its own `Coordinator` that handles the entire flow. So, if the player needs to open the modal, the `ViewController` will directly call the `ViewModel`, which will send a closure action to the `Coordinator` that will have the implementation for that, and will start the next flow.

#### ViewControllers
The view model in this implementation is responsible set up the whole UI, and for handling the user interaction with that UI, to communicate directly with the `ViewModel` to get/fetch/manipulate data.
Speaking about the communication between `View -> ViewController`, as this project is a music player that needs a manager to handle the player status, I decided to call the manager directly from the UI Components. That allows me to have more generic components that can be reused in other parts of the app to control the player itself. That I will explain more in the `PlayerManager` session.

#### ViewModel
In this implementation, the viewModel is responsible for fetch, manipulate and organize the data that will be displayed by the viewController. I decided to have Models for the views that I called `DisplayableContent`, which has the exact elements a view need to display data to users, so I don't need to pass the entire response object to Views that doesn't need to care about it. As I said before, the communication between `ViewModel -> ViewController` is made using Combine, and the communication between `ViewModel -> Coordinator` is made by a closure. 

#### Service
As explained in the `Networking` section, I injected the `MusicPlayerSession` in the Service layer for each feature. This improves the code readability. I didn't used any protocol to expose the service method, as both of the services we have in this implementation only have one method. And even so, I would use private to hide unnecessary methods.

#### PlayerManager
That is the heart of this implementation. I decided to have a singleton `Manager` to handle the player interaction and data. When you select a song, I fulfill that singleton with the searched results, and start playing the song you choose. This manager also controls the play/pause and previous/next features. It is also responsible for managing the song time counter and to update the `Views` subscribed to its `Combine @Published playerState`. Thinking on a future improvement, the idea was to have a single point in the app to manage the player status, and update whichever view is necessary. With this implementation, you can have a floating mini player in the home screen, for example. That player will also be controlled by this same player manager, so any change that you do in the mini player will reflect on the main player, and the other way around as well.

### External Dependencies
I'm only using Kingfisher to download images using the url directly into imageViews. I could do it hard coded, but a little dependency doesn't kill, right? And also demonstrates that I'm fully capable of working with pods and any other dependency manager.

## Tests
### Unit Tests
I pretty much wrote unit test cases for each of the `ViewModels`, `Service Layer`, `Coordinator Layer` and the `PlayerManager`. For this last one I covered all the use cases of the manager like play and pause and next and previous songs, to make sure that all the views subscribed to the `Published` `playerState` will be able to receive the right values. There are 35 Unit tests in this project.

### UITests
These are some integration tests that I wrote, to test each of the flows/features of the app and make sure that all is working good.
There are 6 UI tests in this project.

### Disclaimer
As I used an old Xcode version, you might probably see some errors while running tests. That is a known issue that I had, because of that, here are some evidences of the tests passing:

[Unit Tests](https://imgur.com/a/RMZnUk3)

[UITests](https://imgur.com/a/KVxrLCE)

## Improvements
- Once again, better implementation for UITests. I would like to check each of the elements in the screen, but in that implementation I used the UITests to make some kind of integration test, to check if each flow is behaving correctly
- A feature that I really wanted to implement was to save tracks as favorite, and persist it using Realm.
- One more year, and no SwiftUI, really looking into a professional opportunity to grown my knowledge in that framework :/ 