# 📱 Flutter App Architecture

Este proyecto sigue una estructura modular y escalable para aplicaciones Flutter, separando la lógica de negocio, presentación y datos.

---

## 📁 lib/

### ┣ 📄 main.dart
Punto de entrada de la aplicación (`main()`).

### ┣ 📄 app.dart
Inicializa la configuración global y navegación (`MaterialApp`, rutas, temas, etc.).

---

## 📁 core/

### ┣ 📁 constants/
- **app_colors.dart** – Colores globales de la app.
- **app_strings.dart** – Textos reutilizables.
- **app_sizes.dart** – Tamaños y márgenes estándar.
- **api_endpoints.dart** – 🆕 URLs base del backend.

### ┣ 📁 theme/
- **app_theme.dart** – Configuración del tema general.
- **text_styles.dart** – Estilos de texto reutilizables.

### ┣ 📁 utils/
- **validators.dart** – Validaciones comunes de formularios.
- **http_helper.dart** – 🆕 Configuración genérica para llamadas HTTP.

### ┗ 📁 errors/
- **exceptions.dart** – 🆕 Excepciones personalizadas.
- **failures.dart** – 🆕 Tipos de fallos a manejar en UI/lógica.

---

## 📁 data/

### ┣ 📁 models/
- Modelos para estructurar datos:
  - **user_model.dart**
  - **water_reading_model.dart**
  - **report_model.dart**
  - **api_response_model.dart** – 🆕 Modelo para respuestas de API.

### ┣ 📁 services/
- 🆕 Servicios que realizan llamadas a la API:
  - **auth_service.dart**
  - **user_service.dart**
  - **water_service.dart**
  - **reports_service.dart**

### ┣ 📁 repositories/
- Abstracción de los servicios:
  - **auth_repository.dart**
  - **user_repository.dart**
  - **water_repository.dart**
  - **reports_repository.dart**

### ┗ 📁 local/
- 🆕 Almacenamiento local:
  - **shared_preferences_helper.dart**
  - **secure_storage_helper.dart**

---

## 📁 presentation/

### ┣ 📁 screens/
Pantallas principales de la UI, organizadas por función:
- **auth/** → Pantallas de autenticación.
- **dashboard/** → Panel principal.
- **profile/** → Perfil del usuario.
- **reports/** → Reportes.

### ┣ 📁 widgets/
Componentes UI reutilizables:

#### ┣ 📁 common/
- **custom_button.dart**
- **custom_text_field.dart**
- **bottom_nav_bar.dart**
- **loading_widget.dart** – 🆕 Indicador de carga.

#### ┣ 📁 dashboard/
Widgets específicos del panel:
- **circular_progress_widget.dart**
- **metrics_card.dart**
- **history_item.dart**

#### ┗ 📁 profile/
- **profile_field.dart** – Campo editable de perfil.

### ┗ 📁 providers/
Gestión de estado con `ChangeNotifier`:
- **auth_provider.dart**
- **dashboard_provider.dart**
- **profile_provider.dart**
- **reports_provider.dart**

---

## 📁 routes/

- **app_router.dart** – Controla las rutas y navegación.
- **route_names.dart** – Define los nombres de ruta como constantes.
