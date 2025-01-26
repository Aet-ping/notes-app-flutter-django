# Notes App (Flutter + Django)  

A simple, cross-platform mobile note-taking app built with Flutter for the frontend and Django for the backend. This app allows users to create, edit, and manage notes seamlessly, with data securely stored and synchronized via a Django-powered REST API.  

---

## Features  
- **Create, Edit, and Delete Notes**: Easily manage your notes with a clean and intuitive user interface.  
- **User Authentication**: Simple login and registration system using JWT (JSON Web Tokens).  
- **Backend Integration**: Notes are stored and synchronized with a Django backend using SQLite.  
- **Cross-Platform**: Built with Flutter, the app runs smoothly on both iOS and Android.  

---

## Technologies Used  
- **Frontend**: Flutter (Dart)  
- **Backend**: Django (Python)  
- **Database**: SQLite for development  
- **API**: Django REST Framework (DRF) for building the backend API  
- **Authentication**: JWT (JSON Web Tokens) for secure user authentication  

---

## Setup Instructions  

### Backend (Django)  
1. **Create a Python Virtual Environment**:  
   ```bash  
   python -m venv venv  
   source venv/bin/activate  # On Windows: venv\Scripts\activate  
   ```  

2. **Install Required Packages**:  
   ```bash  
   pip install django djangorestframework djangorestframework-simplejwt  
   ```  

3. **Run the Django Development Server**:  
   Use your local IP address and a port of your choice (e.g., `192.168.1.100:8000`).  
   ```bash  
   python manage.py runserver 192.168.1.100:8000  
   ```  

### Frontend (Flutter)  
1. **Install Flutter Dependencies**:  
   Add the following dependencies to your `pubspec.yaml` file:  
   ```yaml  
   dependencies:  
     dio: ^5.0.0  # For HTTP requests  
     json_theme_plus: ^1.0.0  # For custom themes  
     flutter_secure_storage: ^8.0.0  # For secure token storage  
     responsive_framework: ^0.2.0  # For responsive UI  
   ```  

2. **Run the Flutter App**:  
   ```bash  
   flutter run  
   ```  

---

## Development Notes  
- **Backend URL**: For development purposes, use your local IP address and a port of your choice (e.g., `192.168.1.100:8000`).  
- **Environment Variables**: Store sensitive information (e.g., API keys) in environment variables or a `.env` file.  
- **Database**: Use PostgreSQL for production and SQLite for development.  

---


License
This project is licensed under the MIT License. See the LICENSE file for details.
