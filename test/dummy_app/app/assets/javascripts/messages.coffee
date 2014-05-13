successFadeOut = () -> $('.alert-box.success').fadeOut()

jQuery ->
  setTimeout successFadeOut, 2400 if $('.alert-box.success').length > 0


