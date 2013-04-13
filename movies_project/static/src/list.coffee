raty_custom_settings =
  readOnly : raty_readonly
  click: (score) ->
    # change from null to 0 to simplify saving
    if not score
      score = 0
    change_rating($(this).attr('data-record_id'), score, $(this))

change_rating = (id, rating, element) ->
  revert_to_previous_rating = (element) ->
    score_settings = score: element.attr('data-rating')
    settings = $.extend({}, raty_settings, raty_custom_settings, score_settings)
    element.raty settings

  $.post(url_ajax_change_rating, {id: id, rating: rating},
    (data, error, x) ->
      #update current rating
      element.attr('data-rating', rating)
  ).error ->
    revert_to_previous_rating(element)
    displayError 'Ошибка добавления оценки.'

remove_record = (id) ->
  $.post(url_ajax_remove_record, {id: id},
    (data) ->
      remove_record_from_page(id)
  ).error ->
    displayError 'Ошибка добавления фильма.'
  undefined

switch_mode = (value) ->
  reload = false
  if value is 'minimal'
    if mode is 'full'
      reload = true
    else
      activate_mode_minimal()
      @mode = 'minimal'
  else if value is 'compact' and mode is 'minimal'
    disactivate_mode_minimal()
    @mode = 'compact'
  else
    reload = true
  apply_settings({mode: value}, reload)

switch_sort = (value) ->
  if value isnt 'rating'
    additional_setting = {recommendation: false}
  else
    additional_setting = {}
  settings = jQuery.extend({sort: value}, additional_setting)
  apply_settings(settings)

apply_settings = (settings, reload = true) ->
  $.post(url_ajax_apply_settings, {settings: JSON.stringify(settings)},
    (data) ->
      if reload
        location.reload()
  ).error ->
    displayError 'Ошибка применения настройки.'

save_comment = (id) ->
  comment = $('#comment' + id).val()
  $.post(url_ajax_save_comment, {id: id, comment: comment},
    (data) ->
      if not comment
        toggle_comment_area(id)
  ).error ->
    displayError 'Ошибка сохранения комментария.'

toggle_comment_area = (id) ->
  $('#comment_area' + id).toggle()
  $('#comment_area_button' + id).toggle()
  $('#comment' + id).focus()

activate_mode_minimal = ->
  $('.poster, .comment, .release_date_label, .rating_label').hide()
  $('.details, .review').css('display', 'inline')
  $('.review').css('padding-top', '0')
  $('.release_date, .imdb_rating').css({float: 'right', 'margin-right': '10px'})
  $('.movie').css({'padding-top': '0', 'margin-top': '7px', 'min-height': 'auto'})

disactivate_mode_minimal = ->
  $('.poster, .comment, .release_date_label, .rating_label').show()
  $('.details, .imdb_rating, .review, .release_date').css('display', '')
  $('.review').css('padding-top', '10px')
  $('.release_date, .imdb_rating').css({float: '', 'margin-right': '0'})
  $('.movie').css({'padding-top': '20px', 'margin-top': '0', 'min-height': '145px'})

toggle_recommendation = ->
  if recommendation
    apply_settings({recommendation: false})
  else
    apply_settings({sort: 'rating', recommendation: true})

$ ->
  set_viewed_icons_and_remove_buttons = ->
    if anothers_account
      $('.movie').each(->
        id = $(this).attr('data-id')
        list_id = list_data[id]
        set_viewed_icon_and_remove_buttons(id, list_id)
      )
  $('#button_mode_' + mode).button('toggle')
  if mode is 'minimal'
    activate_mode_minimal()
  $('#button_sort_' + sort).button('toggle')
  if recommendation
    $('#button_recommendation').button('toggle')
  set_viewed_icons_and_remove_buttons()