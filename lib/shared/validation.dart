validateTitle(title) {
  if (title.trim().isEmpty) {
    return "Title can not be empty";
  } else if (title != title) {
    title = title;
  }
  return null;
}

validateDescription(description) {
  if (description.trim().isEmpty) {
    return 'Please enter description';
  }
  return null;
}
