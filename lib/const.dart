final RegExp emailRegExp = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  caseSensitive: false,
);

final RegExp passwordRegExp = RegExp(
  r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$',
);

final RegExp nameRegExp = RegExp(
  r'^[a-zA-Z\s-]+$',
);
