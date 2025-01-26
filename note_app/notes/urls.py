from django.urls import path
from . import views
urlpatterns = [
    path("all_notes/", views.my_notes),
    path("create_note/", views.create_note),
    path("signup/", views.signup),
    path("login/", views.login),
    path("update_note/<int:pk>/", views.updateNote),
    path("delete_note/<int:pk>/", views.deleteNote),
    path('check-access/', views.validate_access_token),
    path('logout/', views.logout),





]
