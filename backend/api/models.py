from django.db import models
from django.contrib.auth.models import User

class Event(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField()
    date = models.DateTimeField()
    location = models.CharField(max_length=100)
    image = models.ImageField(upload_to='event_images/', null=True, blank=True)
    tickets_available = models.IntegerField(default=0)
    duration = models.IntegerField()
    event_type = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)

class Booking(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    event = models.ForeignKey(Event, on_delete=models.CASCADE)
    booked_at = models.DateTimeField(auto_now_add=True)