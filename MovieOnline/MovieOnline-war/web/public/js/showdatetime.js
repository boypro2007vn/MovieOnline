var monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];
var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
function convertDayofMonth(date) {
    if (this % 1)
        return this;
    var s = date % 100;
    if (s > 3 && s < 21)
        return date + 'th';
    switch (s % 10) {
        case 1:
            return date + 'st';
        case 2:
            return date + 'nd';
        case 3:
            return date + 'rd';
        default:
            return date + 'th';
    }
}
function startTime() {
    
    var today = new Date();
    var h = today.getHours();
    var div=document.getElementById("datetime-panel").classList
    if(h >5 && h <18){
        div.add('morning');
    }else{
        div.add('evening');
    }
    var m = today.getMinutes();
    var s = today.getSeconds();
    var y = today.getFullYear();
    var month = monthNames[today.getMonth()];
    var day = days[today.getDay()];
    var date = convertDayofMonth(today.getDate());
    var ap = (h > 12) ? 'PM' : 'AM'
    m = checkTime(m);
    s = checkTime(s);
    document.getElementById("datetime").innerHTML =
            day + '<br>' + month + ' ' + date + ', ' + y + '<br>' + h + ':' + m + ':' + s + ' ' + ap;
    var t = setTimeout(startTime, 500);
}
function checkTime(i) {
    if (i < 10) {
        i = "0" + i
    }
    ;  // add zero in front of numbers < 10
    return i;
}

//server load
var line1 = new TimeSeries();
setInterval(function() {
    line1.append(new Date().getTime(), Math.random());
}, 1000);
var smoothie = new SmoothieChart({
    grid: {
        strokeStyle: 'rgba(68,68,68,0)',
        fillStyle: 'rgba(231,228,241,0)',
        lineWidth: 0,
        millisPerLine: 1000,
        verticalSections: 0,
    },
    labels: {fillStyle: 'rgb(255, 255, 255)'}
});
smoothie.streamTo(document.getElementById("mycanvas"), 1000);
smoothie.addTimeSeries(line1, {strokeStyle: 'rgb(255, 255, 255)', fillStyle: 'rgba(255, 255, 255, 0.4)', lineWidth: 3});

//chart

function formatMoney(num){
    return num.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');
}
var ctx = document.getElementById("userPaymentChart");
var myChart;
if(listUserStatistic != undefined && listUserStatistic !='' && listUserStatistic!= null){
    var from = listUserStatistic[0][0];
    var to =  listUserStatistic[listUserStatistic.length-1][0];
    getListChart(from,to,listUserStatistic,0,$('#statotal').html(),$('#stacountpay').html());
}
function getListChart(from,to,listUserStatistic,year,totalPayment,countUser){
    var year =year;
    var listS=[];
    var timeL = [];
    var avg=0;
    for (var i = from; i<=to; i++) {
        var flag = false;
        var v = 0;
        for(var j = 0;j<listUserStatistic.length;j++){
            if(listUserStatistic[j][0]==i){
                v = listUserStatistic[j][1];
                break;
            }
        }
        listS.push(v);
        if(year!=0){
            timeL.push(monthNames[i-1]);
        }else{
            timeL.push(i)
        }
        avg+=v;
    }
    var totalPay = parseFloat(totalPayment);
    $('#statotal').html(formatMoney(totalPay)+" VND");
    $('#stacountpay').html(countUser);
    if(year!=0){
        $('#avgmonth').css("display","");
        $('#avgyear-label').html("Current Year: ")
        $('#staavgmonth').html(formatMoney(avg/(to-from+1)) +" VND")
        $('#avgyear-value').html(formatMoney(avg) +" VND ("+(100/totalPay*avg).toFixed(2)+"%)")
    }else{
        $('#avgyear-label').html("Average Year: ")
        $('#avgmonth').css("display","none");
        $('#avgyear-value').html(formatMoney(avg/(to-from+1)) +" VND")
    }
    drawChart(timeL,listS,year);
    
}

function drawChart(label,list,year) {
    myChart= new Chart(ctx, {
        type: 'line',
        data: {
            labels: label,
            datasets: [{
                    label: 'Revenue ',
                    data: list,
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255,99,132,1)'
                    ],
                    borderWidth: 2
                }]
        },
        options: {
            responsive: true,
            title: {
                display: true,
                text: year!=0?'REVENUE USER PAYMENT '+year:'REVENUE USER PAYMENT'
            },
            tooltips: {
                mode: 'index',
                intersect: false,
            },
            hover: {
                mode: 'nearest',
                intersect: true
            },
            scales: {
                xAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            labelString: year!=0?'Month':'Year'
                        }
                    }],
                yAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            labelString: 'VND'
                        }
                    }]
            }
        }
    });
    return myChart;
}

function changeChart(year,reset){
    var year = year;
    $.ajax({
            type: 'POST',
            url: "adminHomeStatistic",
            data: {year:year},
            success: function(data, textStatus, jqXHR) {
                myChart.destroy()
                var obj = $.parseJSON(data);
                var from =1;
                var to =12;
                if(reset){
                    from = obj.list[0][0];
                    to = obj.list[obj.list.length-1][0];
                }
                getListChart(from,to,obj.list,year,obj.total,obj.count);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                
            }
      })
}
ctx.ondblclick = function(evt) {
    var activePoints = myChart.getElementsAtEvent(evt);
    if(activePoints.length > 0)
    {
      var clickedElementindex = activePoints[0]["_index"];
      var label = myChart.data.labels[clickedElementindex];
      var value = myChart.data.datasets[0].data[clickedElementindex];
      changeChart(label,false);
   }
}

