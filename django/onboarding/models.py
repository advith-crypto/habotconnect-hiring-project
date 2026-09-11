from django.db import models


class StudentOnboarding(models.Model):
    student_id = models.CharField(max_length=100)
    organization_id = models.CharField(max_length=255)
    student_name = models.CharField(max_length=255)
    onboarding_status = models.CharField(max_length=50)

    class Meta:
        db_table = "student_onboarding"

    def __str__(self):
        return self.student_id