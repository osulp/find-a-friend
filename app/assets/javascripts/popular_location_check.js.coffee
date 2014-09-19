jQuery ->
  window.popular_location_manager = new PopularLocationManager

class PopularLocationManager
  constructor: ->
    @form_selector = this.form_selector()
    this.bind_form()
  bind_form: ->
    @form_selector.submit(this.form_submitted)
  form_selector: -> $("form#new_post")
  form_submitted: (e) =>
    if @valid_form == true
      @valid_form = false
      return
    e.preventDefault()
    this.check_locations()
  check_locations: ->
    @location = @form_selector.find("*[name='post[location]']").val()
    @start_time = @form_selector.find("*[name='post[meeting_time]']").val()
    @end_time = @form_selector.find("*[name='post[end_time]']").val()
    $.getJSON "/posts/query.json", {
      location: @location,
      start: @start_time,
      end: @end_time
    }, this.query_results
  query_results: (data) =>
    return this.location_busy() if data.length >= this.max_length()
    @valid_form = true
    @form_selector.submit()
  max_length: -> 2
  location_busy: ->
    if confirm("This location has multiple events during this time span, are you sure you want to use it?")
      @valid_form = true
      @form_selector.submit()
