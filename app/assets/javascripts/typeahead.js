$(document).ready(function($) {
  var engine = new Bloodhound({
    datumTokenizer: function(d) {return Bloodhound.tokenizers.whitespace(d.location);},
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: {
      // url points to a json file that contains an array of country names, see
      // https://github.com/twitter/typeahead.js/blob/gh-pages/data/countries.json
      url: '../../admin/locations.json'
    }
  })
  engine.initialize();
  window.engine = engine
  $('#myTypeahead').typeahead({
    hint: true,
    highlight: true,
    minLength: 1
  }, {
      valueKey: 'location',
      displayKey: 'location',
      source: engine.ttAdapter()
  });
})
