from django.urls import path
from .views import (
    EventListAPIView,
    EventRetrieveAPIView,
    BookingListCreateAPIView,
    BookingRetrieveUpdateDestroyAPIView,
    UserRegistrationAPIView,
    UserLoginAPIView
)

urlpatterns = [
    # Маршруты для мероприятий
    path('events/', EventListAPIView.as_view(), name='event-list'),
    path('events/<int:pk>/', EventRetrieveAPIView.as_view(), name='event-detail'),

    # Маршруты для бронирований
    path('bookings/', BookingListCreateAPIView.as_view(), name='booking-list-create'),
    path('bookings/<int:pk>/', BookingRetrieveUpdateDestroyAPIView.as_view(), name='booking-detail'),

    # Маршруты для аккаунта
    path('register/', UserRegistrationAPIView.as_view(), name='register'),
    path('login/', UserLoginAPIView.as_view(), name='login'),
]
