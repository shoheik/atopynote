app.views.HomeView = Backbone.View.extend({

    initialize: function () {
        //this.searchResults = new app.models.EmployeeCollection();
        //this.searchresultsView = new app.views.EmployeeListView({model: this.searchResults});
    },

    render: function () {
        this.$el.html(this.template());

        var width = $("#body").width() * 0.90;

        this.$el.find('.graph').each(function(){
            var c = $(this);
            $(window).resize( respondCanvas );
            function respondCanvas(){ 
                c.attr('width', width ); //max width
                c.attr('height', "300" ); //max height
            }
            //Initial call 
            respondCanvas();
        });


        var data = {
        	labels : ["January","February","March","April","May","June","July"],
        	datasets : [
        		{
        			fillColor : "rgba(220,220,220,0.5)",
        			strokeColor : "rgba(220,220,220,1)",
        			pointColor : "rgba(220,220,220,1)",
        			pointStrokeColor : "#fff",
        			data : [65,59,90,81,56,55,40]
        		},
        		{
        			fillColor : "rgba(151,187,205,0.5)",
        			strokeColor : "rgba(151,187,205,1)",
        			pointColor : "rgba(151,187,205,1)",
        			pointStrokeColor : "#fff",
        			data : [28,48,40,19,96,27,100]
        		}
        	]
        }

        var ctx = this.$el.find('#myChart').get(0).getContext("2d");
        new Chart(ctx).Line(data);
        return this;
    },

    //events: {
    //    "keyup .search-key":    "search",
    //    "keypress .search-key": "onkeypress"
    //},

    //search: function (event) {
    //    var key = $('.search-key').val();
    //    this.searchResults.fetch({reset: true, data: {name: key}});
    //},

    //onkeypress: function (event) {
    //    if (event.keyCode === 13) { // enter key pressed
    //        event.preventDefault();
    //    }
    //}

});
