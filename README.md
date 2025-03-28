# Tractian Mobile Challenge - Tractian

Welcome to the repository of my project developed as a solution for Tractian's mobile challenge! This application was created to demonstrate my mobile development skills, using Flutter to build a functional application that meets the challenge's requirements.

## About the Challenge

The Tractian mobile challenge proposes the creation of an application to manage industrial asset information, allowing the visualization of an asset list, filtering by name, and navigation through a hierarchical structure of locations. The goal is to consume data from a provided API, display the information clearly, and offer a smooth and intuitive user experience.

This project was developed as part of Tractian's technical evaluation process, highlighting my ability to implement modern and efficient mobile solutions.

## Features

- **Asset and Location Visualization**: Displays a detailed list of assets and locations dynamically retrieved via API.  
- **Smart Search**: Quickly locate assets and locations through an optimized search field.  
- **Hierarchical Navigation**: Interactive tree structure to intuitively explore locations, assets, and sub-locations.  
- **Adaptive Interface**: Responsive layout ensuring a smooth experience across different devices and screen sizes.  
- **Enhanced Offline Support**: Stores data in a local database to optimize queries, reducing the need for multiple API requests.

## Technologies Used  

- **Flutter**: Main framework used for application development.  
- **Environment Variable Management**: `flutter_dotenv` - Used to securely load environment variables.  
- **Dependency Injection and Navigation**: `flutter_modular` - Responsible for dependency injection and route management.  
- **State Management**: `ChangeNotifier` - Implemented for efficient application state control.  
- **HTTP Requests**: `Dio` - Robust library for API communication.  
- **Local Persistence**: `Sqflite` - Used for local data storage and management.  
- **Automated Testing**: `Mockito` - Tool for creating mocks and facilitating unit tests.  

## How to Run the Project

### Prerequisites
- Flutter SDK
- An emulator or physical device for testing.

### Steps
1. **Clone the repository**:
   ```bash
   git clone https://github.com/vitoramerico/tractian.git
   ```
2. **Access the project directory**:
   ```bash
   cd tractian
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the application**:
   ```bash
   flutter run
   ```

Ensure that the Tractian API (or an equivalent mock API) is accessible for the application to function correctly.

## Project Structure

```
📂 [your-repository]
├── 📂 lib                      # Main source code
    ├── 📂 src                  # Main source code
    │   ├── 📂 core             # Shared configurations and utilities (e.g., themes, constants, generic services)
    │   ├── 📂 data             # Data layer (e.g., models, repositories, API integration)
    │   ├── 📂 domain           # Business logic (e.g., use cases, entities)
    │   ├── 📂 presenter        # Presentation layer (e.g., screens, widgets, state management)
    │   📜 main.dart            # Application entry point
├── 📜 pubspec.yaml             # Dependencies and configurations (Flutter)
└── 📜 README.md                # This file
```

## Challenges Faced

- **API Integration**: Ensuring requests were efficient and handled errors appropriately.
- **Filtering**: Implementing a search that dynamically updates the list without compromising performance.
- **Ensuring Low Memory Usage**: A major challenge was loading large amounts of data without compromising performance. To solve this, data is saved in the database after being downloaded to enable faster queries and maintain good performance.

## Possible Improvements  

- **Filter Optimization**: Implement filtering on the back-end to reduce the amount of returned data, improving performance.  
- **Animations and UX**: Add transitions and visual effects to make the user experience smoother and more interactive.  
- **Hierarchical Visualization Enhancement**: Improve the presentation of the asset and location tree to facilitate navigation and usability.  
- **Multilingual Support**: Implement translations for different languages, making the application globally accessible.  

#### Video:
[Demonstration Video](https://raw.githubusercontent.com/vitoramerico/tractian/main/video.mp4)

## Contact

If you have any questions or suggestions about the project, feel free to contact me:

- **GitHub**: [vitoramerico]
- **Email**: [vitorh.americo@gmail.com]