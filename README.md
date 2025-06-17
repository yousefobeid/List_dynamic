# 🧩 Dynamic Form App (Flutter + BLoC)

A powerful, flexible, and reusable **dynamic form builder** in Flutter using **BLoC architecture**, capable of rendering UI from a JSON schema with support for complex behaviors like conditional fields, validation, and read-only previews.

---

## 🚀 Features

- 🔄 Fully **dynamic form generation** from JSON
- 🧠 Smart **field dependencies & conditional logic** (e.g., age changes based on selected gender)
- ✅ **Validation system** with error handling
- 👁️ Read-only **review mode** for submitted data
- 🧪 Includes **unit & integration tests**
- 📱 Clean, responsive UI with modular widgets
- 🧼 Follows **Clean Architecture + BLoC pattern**

---

## 🧱 Project Structure

```
lib/
├── blocs/              # BLoC files (FormBloc, FourmState, FormEvents)
├── models/             # Data models (FormElementModel, OptionModel, etc.)
├── screens/            # UI screens (FormPage, ReviewPage)
├── services/           # Business logic, validation, JSON parsing
├── widgets/            # Reusable form widgets (e.g., TextInput, Dropdown, RadioGroup)
└── main.dart
```

---

## 🧪 Testing

### ✅ Unit Tests

Test form logic, validation rules, and state management:

```bash
flutter test test/unit/
```

### ✅ Integration Tests

Simulate user behavior through the full form flow:

```bash
flutter test integration_test/
```

---

## 🧠 Example JSON Schema

Supports `textField`, `dropdown`, `radio`, `date_picker`, `button`, and dependencies:

```json
[
  {
    "type": "radio",
    "label": "Gender",
    "field": "gender",
    "required": true,
    "options": ["Male", "Female"]
  },
  {
    "type": "dropdown",
    "label": "Age",
    "field": "age",
    "required": true,
    "depends_on": {
      "field": "gender",
      "Male": [20, 21, 22],
      "Female": [18, 19, 20]
    }
  },
  {
    "type": "button",
    "label": "Submit"
  }
]
```

---

## 🛠 Getting Started

1. **Clone the repo**

   ```bash
   git clone https://github.com/your-username/dynamic_form_app.git
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 🎯 Use Cases

- Form-based registration apps
- Surveys and questionnaires
- Admin panels with dynamic field structures
- Review + edit flows

---

## 🧑‍💻 Author

**Yousef Obid** – Flutter Developer  
🔗 [LinkedIn](https://www.linkedin.com/in/yousef-obid-9301052b5/)  
📧 yousefobid521@gmail.com

---

## 📄 License

This project is licensed under the MIT License.
