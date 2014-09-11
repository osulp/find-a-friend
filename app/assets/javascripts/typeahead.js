$(document).ready(function($) {
  var engine = new Bloodhound({
    datumTokenizer: function(d) {return Bloodhound.tokenizers.whitespace(d.location);},
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: {  
      ttl: 1, 
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
