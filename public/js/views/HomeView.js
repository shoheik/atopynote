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
        this.basechart.fetch({
            success: function(data){
                var ctx = self.$el.find('#myChart').get(0).getContext("2d");
                new Chart(ctx).Line(data.attributes, {
                    scaleOverlay : false,
	                scaleOverride : true,
	                scaleSteps : 5,
	                scaleStepWidth : 1,
	                scaleStartValue : null,
	                scaleLineColor : "#9c9985",
	                scaleLineWidth : 1,
	                scaleShowLabels : true,
	                scaleLabel : "<%=value%>",
	                scaleFontFamily : "'Arial'",
	                scaleFontSize : 11,
	                scaleFontStyle : "normal",
	                scaleFontColor : "#9c9985",	
	                scaleShowGridLines : false,
	                scaleGridLineColor : "#bebda5",
	                scaleGridLineWidth : 1,	
	                bezierCurve : false,
	                pointDot : true,
	                pointDotRadius : 6,
	                pointDotStrokeWidth : 0,
	                datasetStroke : true,
	                datasetStrokeWidth : 3,
	                datasetFill : false,
	                animation : true,
	                animationSteps : 60,
	                animationEasing : "easeOutQuart",
	                onAnimationComplete : null	
                });
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
