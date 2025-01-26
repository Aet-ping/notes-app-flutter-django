from rest_framework.response import Response
from rest_framework import status
from .models import Note, CustomUser
from .serializers import NoteSerializer ,SignupSerializer, LoginSerializer, SingleNoteSerializer
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.tokens import AccessToken, RefreshToken
from rest_framework_simplejwt.exceptions import TokenError

@api_view(['POST'])
@permission_classes([AllowAny])
def logout(request):
    try:
        refresh_token = request.data["refresh_token"]
        token = RefreshToken(refresh_token)
        token.blacklist() 
        return Response(status=status.HTTP_205_RESET_CONTENT)
    
    except Exception as e:
        print(e)
        return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([AllowAny])
def login(request):
    serializer = LoginSerializer(data=request.data)
    if serializer.is_valid():
        return Response(serializer.validated_data, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([AllowAny])
def signup(request):
    serializer = SignupSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({"message": "User registered successfully!"}, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([AllowAny])
def create_note(request):
    data = request.data.copy()  
    serializer = SingleNoteSerializer(data=data)
    if serializer.is_valid():
        serializer.save(user=request.user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
@permission_classes([AllowAny])
def my_notes(request):
    if not request.user.is_authenticated:
        return Response({"detail": "Authentication credentials were not provided."}, status=status.HTTP_401_UNAUTHORIZED)
    user_notes = Note.objects.filter(user=request.user)
    serializer = NoteSerializer(user_notes, many=True)
    return Response (serializer.data)


@api_view(['PUT'])
@permission_classes([AllowAny])
def updateNote(request, pk):
    try:
        OneNote = Note.objects.get(id=pk)
    except OneNote.DoesNotExist:
        return Response({"error": "Note not found"}, status=status.HTTP_404_NOT_FOUND)
    

    data = request.data.copy()  

    serializer = SingleNoteSerializer(OneNote,data=data)
    if serializer.is_valid():
        serializer.save(user=request.user)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
@permission_classes([AllowAny])
def deleteNote(request, pk):
    try:
        OneNote = Note.objects.get(id=pk, user=request.user)
    except OneNote.DoesNotExist:
        return Response({"error": "Note not found"}, status=status.HTTP_404_NOT_FOUND)
    OneNote.delete()
    return Response({"message": "Note deleted successfully"}, status=status.HTTP_204_NO_CONTENT)

@api_view(['POST'])
@permission_classes([AllowAny])
def validate_access_token(request):
    token = request.data.get('access', None)

    if not token:
        return Response({"detail": "access token not provided."}, status=400)

    try:
        AccessToken(token)  
        return Response({"detail": "access token is valid."}, status=200)
    except TokenError as e:
        return Response({"detail": "access token is invalid or expired.", "error": str(e)}, status=401)

