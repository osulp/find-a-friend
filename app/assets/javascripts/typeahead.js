$(document).ready(function($) {
  var engine = new Bloodhound({
    name: 'Stuff',
    local: [{value: "Deluxe Bicycle"}, {value: "Super Deluxe Trampoline"}, {value: "Super Duper Scooter"}],
    datumTokenizer: function(d) {return Bloodhound.tokenizers.whitespace(d.value);},
    queryTokenizer: Bloodhound.tokenizers.whitespace
  })
  engine.initialize();
  window.engine = engine
  $('#myTypeahead').typeahead({
    hint: true,
    highlight: true,
    minLength: 1
  }, {
      source: engine.ttAdapter()
  });
})
