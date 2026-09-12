from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from .serializers import StudentOnboardingSerializer


class StudentOnboardingView(APIView):
    def post(self, request):
        serializer = StudentOnboardingSerializer(data=request.data)

        if serializer.is_valid():
            student = serializer.save()

            return Response(
                StudentOnboardingSerializer(student).data,
                status=status.HTTP_201_CREATED,
            )

        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST,
        )