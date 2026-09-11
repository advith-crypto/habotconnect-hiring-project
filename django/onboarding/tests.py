from django.test import SimpleTestCase

from .dcyn import normalize_yes_no


class DCYNTests(SimpleTestCase):
    def test_yes_is_true(self):
        self.assertTrue(normalize_yes_no("Yes"))

    def test_no_is_false(self):
        self.assertFalse(normalize_yes_no("No"))

    def test_case_and_whitespace_are_normalized(self):
        self.assertTrue(normalize_yes_no("  YES  "))
        self.assertFalse(normalize_yes_no(" no "))

    def test_invalid_value_is_rejected(self):
        with self.assertRaises(ValueError):
            normalize_yes_no("Maybe")
from rest_framework import serializers

from .serializers import YesNoField


class YesNoSerializer(serializers.Serializer):
    response = YesNoField()


class YesNoFieldTests(SimpleTestCase):
    def test_yes_is_converted_to_true(self):
        serializer = YesNoSerializer(data={"response": "Yes"})

        self.assertTrue(serializer.is_valid())
        self.assertIs(serializer.validated_data["response"], True)

    def test_no_is_converted_to_false(self):
        serializer = YesNoSerializer(data={"response": "No"})

        self.assertTrue(serializer.is_valid())
        self.assertIs(serializer.validated_data["response"], False)

    def test_invalid_value_is_rejected(self):
        serializer = YesNoSerializer(data={"response": "Maybe"})

        self.assertFalse(serializer.is_valid())
        self.assertIn("response", serializer.errors)
from .serializers import StudentOnboardingSerializer


class StudentOnboardingSerializerTests(SimpleTestCase):
    def test_valid_student_onboarding_data(self):
        data = {
            "student_id": "STU001",
            "organization_id": "ORG001",
            "student_name": "Test Student",
            "onboarding_status": "pending",
        }

        serializer = StudentOnboardingSerializer(data=data)

        self.assertTrue(serializer.is_valid())
        self.assertEqual(serializer.validated_data["student_id"], "STU001")
        self.assertEqual(
            serializer.validated_data["organization_id"],
            "ORG001",
        )

    def test_missing_required_field_is_rejected(self):
        data = {
            "student_id": "STU001",
            "organization_id": "ORG001",
            "student_name": "Test Student",
        }

        serializer = StudentOnboardingSerializer(data=data)

        self.assertFalse(serializer.is_valid())
        self.assertIn("onboarding_status", serializer.errors)