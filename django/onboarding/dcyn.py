"""
Deterministic Yes/No (DCYN) validation library.

This module provides a single, reusable normalization function for
binary Yes/No values received from onboarding data.

The actual onboarding fields and their exact validation limits will be
implemented only after those requirements are available.
"""

YES_VALUES = {"yes"}
NO_VALUES = {"no"}


def normalize_yes_no(value: str) -> bool:
    """
    Convert a Yes/No value into a deterministic Boolean result.

    Returns:
        True for "Yes".
        False for "No".

    Raises:
        ValueError: If the value is not an accepted Yes/No value.
    """
    if not isinstance(value, str):
        raise ValueError("The value must be a string containing Yes or No.")

    normalized_value = value.strip().lower()

    if normalized_value in YES_VALUES:
        return True

    if normalized_value in NO_VALUES:
        return False

    raise ValueError("The value must be exactly Yes or No.")