from rest_framework import serializers
from .models import Note, CustomUser
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth.hashers import make_password


class NoteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Note
        fields = '__all__'

class SingleNoteSerializer(serializers.ModelSerializer):
    class Meta:
        model= Note
        fields = ['title', 'content']  
        extra_kwargs = {
            'title': {'required': True},
            'content': {'required': True},
        }

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = '__all__'

class SignupSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['email', 'password']  
        extra_kwargs = {
            'password': {'write_only': True}  
        }

    def validate_password(self, value):
        if len(value) < 8:
            raise serializers.ValidationError("Password must be at least 8 characters long.")
        return value

    def create(self, validated_data):
        validated_data['password'] = make_password(validated_data['password']) 
        return super().create(validated_data)

class LoginSerializer(serializers.Serializer):
    email = serializers.CharField()
    password = serializers.CharField(write_only=True)

    def validate(self, data):
        email = data.get('email')
        password = data.get('password')
        print(email)
        # Authenticate user
        user = authenticate(email=email, password=password)
        if not user:
            raise serializers.ValidationError("Invalid username or password")

        # Generate tokens
        refresh = RefreshToken.for_user(user)
        return {
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'email': user.email
        }
