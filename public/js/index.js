/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
        iTP;
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicity call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

//=============================================================================
// iTP is main application
//=============================================================================
var iTP = (function(){

    // Display Today's date and store the date
    var DateView = Backbone.View.extend({
        el: $('#date'),
        initialize: function(){
            this.render();
        },
        render: function(){
            var dd = new Date();
            var month = dd.getMonth() + 1;
            var date = dd.getDate() + 1;
            var year = dd.getYear() + 1900;
            this.$el.html(year + "年" + month + "月" + date + "日");
            // TODO add date model
        }
    });

    var SubmitView = Backbone.View.extend({
        el: $("#submition"),
        events: {
            "click #submit_record": "submitRecord"
        },
        submitRecord: function(){
            this.model.set("itch", $('input#itch').val());
            this.model.set("feeling", $('input#feeling').val());
            this.model.set("stress", $('input#stress').val());
            this.model.set("sleep", $('input#sleep').val());
            this.model.set("bowels", $('input#bowels').val());
            this.model.set("excercise", $('select#excercise').val());
            var food = [];
            $('[name="food"]:checked').each(function(){
                food.push($(this).attr('id'));
            });
            console.log(food);
            this.model.set("food", food);
            console.log(this.model.toJSON());

            this.model.save({abc: '1'},{ success : function(model, res){ console.log(res); }});
        }
    });

    var RecordModel = Backbone.Model.extend({
        //urlRoot : "/submit",
        url: "http://127.0.0.1:3000/submit"
    });

    var record = new RecordModel();

    var submit_record = new SubmitView({model: record });
    var date_view = new DateView();

})();

