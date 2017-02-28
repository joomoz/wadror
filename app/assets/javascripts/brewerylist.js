var BREWERIES = {};

BREWERIES.show = function(){
    $("#brewerytable tr:gt(0)").remove();

    var table = $("#brewerytable");

    $.each(BREWERIES.list, function (index, brewery) {
        table.append('<tr>'
                        +'<td>'+brewery['name']+'</td>'
                        +'<td>'+brewery['year']+'</td>'
                        +'<td>'+brewery['beers']['n_beers']+'</td>'
                        +'<td>'+brewery['status']['active']+'</td>'
                    +'</tr>')
    });
};

BREWERIES.sort_by_name = function(){
    BREWERIES.list.sort( function(a,b){
        return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    });
};

BREWERIES.sort_by_year = function(){
    BREWERIES.list.sort( function(a,b){
        return a.year>(b.year);
    });
};

BREWERIES.sort_by_n_beers = function(){
    BREWERIES.list.sort( function(a,b){
        return a.beers.n_beers>(b.beers.n_beers);
    });
};

BREWERIES.sort_by_activity = function(){
    BREWERIES.list.sort( function(a,b){
        return a.status.active<(b.status.active);
    });
};

$(document).ready(function () {

      $.getJSON('breweries.json', function (breweries) {
          BREWERIES.list = breweries;
          BREWERIES.sort_by_name();
          BREWERIES.show();
       });

      $("#name").click(function (e) {
          BREWERIES.sort_by_name();
          BREWERIES.show();
          e.preventDefault();
      });

      $("#year").click(function (e) {
          BREWERIES.sort_by_year();
          BREWERIES.show();
          e.preventDefault();
      });

      $("#n_beers").click(function (e) {
          BREWERIES.sort_by_n_beers();
          BREWERIES.show();
          e.preventDefault();
      });

      $("#active").click(function (e) {
          BREWERIES.sort_by_activity();
          BREWERIES.show();
          e.preventDefault();
      });

});
