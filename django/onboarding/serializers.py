from rest_framework import serializers

from .dcyn import normalize_yes_no


class YesNoField(serializers.CharField):
    """
    Django REST Framework field for deterministic Yes/No validation.

    The validated representation is a Boolean:
    Yes -> True
    No -> False
    """

    def to_internal_value(self, data):
        value = super().to_internal_value(data)

        try:
            return normalize_yes_no(value)
        except ValueError as exc:
            raise serializers.ValidationError(str(exc)) from exc
from .models import StudentOnboarding


class StudentOnboardingSerializer(serializers.ModelSerializer):
    class Meta:
        model = StudentOnboarding
        fields = [
            "student_id",
            "organization_id",
            "student_name",
            "onboarding_status",
        ]