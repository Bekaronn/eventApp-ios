# Generated by Django 5.0.3 on 2024-05-06 15:13

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_rename_date_time_event_date_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='event',
            name='duration',
            field=models.IntegerField(default=0),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='event',
            name='event_type',
            field=models.TextField(default=0),
            preserve_default=False,
        ),
    ]
