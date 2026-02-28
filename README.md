# 🌿 BotanyBase

A Flutter application for exploring plant species, pest & disease information, and daily plant discovery — powered by the [Perenual API](https://perenual.com) and the [HK Observatory Weather API](https://data.weather.gov.hk).

---

## Features

- **Plant List** — Browse a searchable catalog of plant species.
- **Plant Details** — View in-depth info for any plant (description, care guide, images, etc.).
- **Random Plant** — Discover a random plant of the day, complete with weather context (rainfall data).
- **Pest & Disease** — Look up common pests and diseases affecting plants.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| HTTP Client | [Dio](https://pub.dev/packages/dio) `^5.9.1` |
| Env Config | [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) `^6.0.0` |
| Icons | Cupertino Icons |

---

## Project Structure

```
lib/
├── features/                  # UI pages & domain entities
│   ├── plant_list_page.dart
│   ├── plant_details_page.dart
│   ├── plant_details_entity.dart
│   ├── random_plant_page.dart
│   ├── random_plant_entity.dart
│   ├── pest_disease_list_page.dart
│   └── pest_disease_entity.dart
├── services/                  # API service layer
│   ├── dio_client.dart
│   ├── plant_api_service.dart
│   ├── weather_api_service.dart
│   └── exceptions.dart
└── main.dart
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.10.8`
- A valid [Perenual API key](https://perenual.com/docs/api)

### Setup

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd botanybase
   ```

2. **Create a `.env` file** in the project root:

   ```env
   PERENUAL_API_KEY=your_api_key_here
   ```

3. **Install dependencies**

   ```bash
   flutter pub get
   ```

4. **Run the app**

   ```bash
   flutter run
   ```

---

## APIs Used

| API | Purpose |
|---|---|
| `https://perenual.com/api/v2/species-list` | Plant species catalog |
| `https://perenual.com/api/v2/species/details/{id}` | Plant detail lookup |
| `https://perenual.com/api/v2/pest-disease-list` | Pest & disease data |
| `https://data.weather.gov.hk/weatherAPI/opendata/hourlyRainfall.php` | Rainfall data (HK Observatory) |
