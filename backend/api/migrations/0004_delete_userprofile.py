# Generated by Django 5.0.3 on 2024-05-06 15:50

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0003_alter_event_duration_alter_event_event_type'),
    ]

    operations = [
        migrations.DeleteModel(
            name='UserProfile',
        ),
    ]
