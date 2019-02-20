<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
<#include "/base/findProductInputType.ftl"/>
<link rel="stylesheet" href="/vst_admin/css/calendar.css" type="text/css"/>

</head>
<body>
<div class="iframe_header">
    <ul class="iframe_nav">
        <li><a href="#">行程维护</a> &gt;</li>
        <li class="active">查看所有行程适用出发日期</li>
    </ul>
</div> 

<div class="iframe_content mt15">
	<span style="font-weight:bold;font-size:15px;">行程展示</span>
	<a style="font-size:13px;margin-left:10px;" href="/vst_admin/prod/prodLineRoute/showUpdateRoute.do?productId=${productId}">返回行程</a>
	<input type="hidden" id="productId" value="${productId}" />
</div>

<div class="iframe_content mt10">
	<div id="timePriceDiv" class="time_price"></div>
</div>
<#include "/base/foot.ftl"/>
</body>
</html>
<script src="/vst_admin/js/pandora-calendar.js"></script>

<script>
	var good = {};
	var globalIndex = 0;
	var specDate;
         
 	var template = {
        warp: '<div class="ui-calendar"></div>',
        calControl: '<span class="month-prev" {{stylePrev}} title="上一月">‹</span><span class="month-next" {{styleNext}} title="下一月">›</span>',
        calWarp: '<div class="calwarp clearfix">{{content}}</div>',
        calMonth: '<div class="calmonth">{{content}}</div>',
        calTitle: '<div class="caltitle"><span class="mtitle">{{month}}</span></div>',
        calBody: '<div class="calbox">' +
                    '<i class="monthbg">{{month}}</i>' +
                    '<table cellspacing="0" cellpadding="0" border="0" class="caltable">' +
                        '<thead>' +
                            '<tr>' +
                                '<th class="sun">日</th>' +
                                '<th class="mon">一</th>' +
                                '<th class="tue">二</th>' +
                                '<th class="wed">三</th>' +
                                '<th class="thu">四</th>' +
                                '<th class="fri">五</th>' +
                                '<th class="sat">六</th>' +
                            '</tr>' +
                        '</thead>' +
                        '<tbody>' +
                            '{{date}}' +
                        '</tbody>' +
                    '</table>' +
                '</div>',
        weekWarp: '<tr>{{week}}</tr>',
        day: '<td {{week}} {{dateMap}} >' +
                '<div {{className}}>' +
                    '<span class="calday">{{day}}</span>' +
                    '<span class="calinfo"></span>' +
                    '<div class="fill_data"></div>' +
                '</div>' +
             '</td>'
    };
         
   	//填充日历数据
    function fillData() {
        var that = this,
        url = "/vst_admin/prod/prodLineRoute/getRouteName.do";
		
        var month = that.options.date.getMonth();
        var year = that.options.date.getFullYear();
        var day = that.options.date.getDate();
        specDate = year + "-" + (month+1) + "-" + day;
        function setData(data) {
            if(data === undefined) {
                return;
            }
            data.forEach(function (arr) {
                var $td = that.warp.find("td[date-map=" + arr.specDateStr + "]");
                var liArray = [];
                //适用行程
                if(arr.routeName!=null){
                  liArray.push('<li class="mb10"><span class="cc3">适用行程:'+arr.routeName+'</li>');
                }   
                $td.find("div.fill_data").append("<ul>"+liArray.join('')+"</ul>");
            });
         }
        
        //将分钟数转换为天/时/分
        function minutesToDate(time){
        	var time = parseInt(time);
			var day=0;
			var hour=0;
			var minute=0;
			if(time >  0){
				day = Math.ceil(time/1440);
				if(time%1440==0){
					hour = 0;
					minute = 0;
				}else {
					hour = parseInt((1440 - time%1440)/60);
					minute = parseInt((1440 - time%1440)%60);
				}
				
			}else if(time < 0 ){
				time = -time;
				hour = parseInt(time/60);
				minute = parseInt(time%60);
			}
			if(hour<10)
				hour = "0"+hour;
			if(minute<10)
				minute = "0"+minute;
			return day+"天"+hour+"点"+minute+"分";
        }
        
        $.ajax({
            url: url,
            type: "POST",
            dataType: "JSON",
            data : {"productId":$("#productId").val() ,"specDate":specDate},
            success: function(json) {
            
              setData(json);
            },
            error: function () { }
        });
    }

     function refresh(){
        pandora.calendar({
            sourceFn: fillData,
            autoRender: true,
            frequent: true,
            showNext: true,
            mos :0,
            template: template,
            target: $("#timePriceDiv")
        });
     }
     refresh();
</script>