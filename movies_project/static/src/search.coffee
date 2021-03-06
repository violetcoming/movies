search_type = 1

jQuery.validator.setDefaults success: 'valid'

displayMovie = (movie) ->
  html = """
            <div class="movie" id="movie#{ movie.id }">
            <div class="poster"><img src="#{ movie.poster }" alt="#{ movie.title } poster"/></div>
            <div class="title">#{ movie.title }
              <div class="add-to-list-buttons">
                <a href="#" title="Добавить в список \"Просмотрено\"" onclick="add_to_list_from_db(#{ movie.id }, 1)"><i class="fa fa-eye"></i></a>
                <a href="#" title="Добавить в список \"К просмотру\"" onclick="add_to_list_from_db(#{ movie.id }, 2)"><i class="fa fa-eye-slash"></i></a>
              </div>
            </div>
            <div class="details">
         """
  if movie.release_date
    html += """<strong>Дата выпуска:</strong> #{ movie.release_date }"""
  html += '</div></div>'
  $('#results').append(html)

search_movie = ->
  isChecked = (id) ->
    if $("##{ id }:checked").val()
      1
    else
      0

  $('#results').empty()
  popular_only = isChecked('popular_only')
  sort_by_date = isChecked('sort_by_date')
  options =
    popular_only: popular_only
    sort_by_date: sort_by_date

  $.post(url_ajax_search_movie,
    query: $('#query').val()
    type: search_type.toString()
    options: options, (data) ->
      if data.status is 1
        jQuery.each(data.movies,
          (i, movie) ->
            displayMovie(movie)
        )
      else if data.status is 0
        $('#results').html 'Ничего не найдено'
      else
        display_message 'Ошибка поиска'
  ).error ->
    display_message 'Ошибка поиска'

add_to_list_from_db = (movie_id, list_id) ->
  $.post(url_ajax_add_to_list_from_db,
    movie_id: movie_id
    list_id: list_id,
    (data) ->
      if data.status is -1
        display_message 'Ошибка! Код #1'
      else if data.status is -2
        display_message 'Ошибка! Код #2'
      else
        $('#movie' + movie_id).fadeOut('fast',
          ->
            $(this).remove()
        )
  ).error ->
    display_message 'Ошибка добавления фильма'

change_search_type = (id) ->
  if id is 1
    text = 'Фильм'
    search_type = 1
  if id is 2
    text = 'Актёр'
    search_type = 2
  if id is 3
    text = 'Режиссёр'
    search_type = 3
  html = """ #{ text } <span class="caret"></span> """
  $('#search_type_button').html html

$ ->
  $('#query').focus()
  $('#search').validate(
    rules:
      query: 'required'
    messages:
      query: 'Введите запрос.'
    errorPlacement: (error, element) ->
      $('#error').html(error)
    submitHandler: (form) ->
      search_movie()
  )