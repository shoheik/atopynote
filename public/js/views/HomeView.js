app.views.HomeView = Backbone.View.extend({

    initialize: function () {
        //this.searchResults = new app.models.EmployeeCollection();
        //this.searchresultsView = new app.views.EmployeeListView({model: this.searchResults});
        //this.dates = new app.models.DateCollection();
        // this.dateView = new app.views.DateView({ collection: this.dates }); 
        this.basechart = new app.models.BaseChart();
        
    },

    render: function () {
        this.$el.html(this.template());

        // For responsive canvas
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

        // Use adapter to retrieve data
        var self = this;
        var data = this.basechart.fetch({
            success: function(data){
                var ctx = self.$el.find('#myChart').get(0).getContext("2d");
                new Chart(ctx).Line(data.attributes);
            }
        });
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
