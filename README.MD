# Khubzati Monorepo

Welcome to the Khubzati monorepo, which contains multiple packages for the Khubzati project. This monorepo is managed using [Melos](https://pub.dev/packages/melos) to streamline the development process.

## Structure

- **packages/khubzati_app**: The main Flutter application for Khubzati.
- **packages/khubzati_components**: Shared components and utilities used across the Khubzati project.

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.
- [Melos](https://pub.dev/packages/melos) for managing the monorepo.

### Setup

1. **Clone the repository**:

   ```bash
   git clone <repository-url>
   cd khubzati
   ```

2. **Bootstrap the workspace**:

   Use Melos to bootstrap the workspace, which will install dependencies and link packages.

   ```bash
   melos bootstrap
   ```

3. **Run the App**:

   You can run the `khubzati_app` using the following command:

   ```bash
   make melos-run
   ```

## Development

### Common Commands

- **Analyze Code**:

  ```bash
  make analyze
  ```

- **Clean Project**:

  ```bash
  make clean
  ```

- **Generate Code**:

  Use build_runner to generate code for the project.

  ```bash
  make runner-build
  ```

- **Watch for Code Changes**:

  Automatically rebuild code on changes.

  ```bash
  make runner-watch
  ```

- **Remove Unused Imports**:

  ```bash
  make remove-unused-import
  ```

- **Check for Outdated Packages**:

  ```bash
  make outdated
  ```

## Contributing

Contributions are welcome! Please follow the [contribution guidelines](CONTRIBUTING.md) to submit issues or pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.