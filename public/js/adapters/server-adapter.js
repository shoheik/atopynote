// Obtain charts from memory for dev purpose
app.adapters.chart = (function () {

    var data = {
            labels : ["2013-08-01","","","","","2013-08-08","2013-08-15","2013-08-22","2013-08-29"],
            datasets : [
                    {
			                fillColor : "rgba(0,180,255,0.1)",
			                strokeColor : "#62a9dd",
			                pointColor : "#62a9dd",
			                pointStrokeColor : "#fff",
                            data : [0,1,1,1,5,5,5,3,4,3,2,1]
                    },
                    {
                            fillColor : "rgba(151,187,205,0.5)",
                            strokeColor : "#db6a6a",
                            pointColor : "#db6a6a",
                            pointStrokeColor : "#fff",
                            data : [3,3,3,4,5,5,3,6,3,6,]
                    }
            ]
    };

    var getBaseChart = function(id) {
        var defferred = $.get("/homeview", function(res){
            return res;
        });
        return defferred; 
    };

    // The public API
    return {
        getBaseChart: getBaseChart
    };

}());
