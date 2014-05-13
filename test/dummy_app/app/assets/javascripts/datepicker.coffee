$ ->
  $("input.datepicker").each (i) ->
    $(this).next().val($(this).val())
    $(this).datepicker
      altFormat: "yy-mm-dd"
      dateFormat: "yy-mm-dd"
      altField: $(this).next()
