from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .models import Event, Booking
from .serializers import EventSerializer, BookingSerializer, UserSerializer
from django.contrib.auth.models import User
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.tokens import AccessToken

class UserRegistrationAPIView(generics.CreateAPIView):
    serializer_class = UserSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response({'message': 'User registered successfully'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserLoginAPIView(TokenObtainPairView):
    serializer_class = TokenObtainPairSerializer

class UserRetrieveAPIView(generics.RetrieveAPIView):
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

    def get_object(self):
        return self.request.user


class EventListAPIView(generics.ListAPIView):
    serializer_class = EventSerializer

    def get_queryset(self):
        queryset = Event.objects.all()
        event_type = self.request.query_params.get('event_type', None)
        title = self.request.query_params.get('title', None)

        if event_type:
            queryset = queryset.filter(event_type__icontains=event_type)

        if title:
            queryset = queryset.filter(title__icontains=title)

        return queryset

class EventRetrieveAPIView(generics.RetrieveAPIView):
    queryset = Event.objects.all()
    serializer_class = EventSerializer


class BookingRetrieveUpdateDestroyAPIView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer
    permission_classes = [IsAuthenticated]  
    authentication_classes = [JWTAuthentication]

class BookingListCreateAPIView(generics.ListCreateAPIView):
    serializer_class = BookingSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        queryset = Booking.objects.filter(user=user)
        return queryset

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)