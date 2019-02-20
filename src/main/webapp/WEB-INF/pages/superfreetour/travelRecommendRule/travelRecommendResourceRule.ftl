<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <title>资源组合规则设置</title>
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css" />
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/vst/subcompany/base.css" />
	<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/lv/calendar.css,/styles/lv/buttons.css,/styles/lv/dialog.css,/styles/lv/icons.css">
	<link rel="stylesheet" href="http://pic.lvmama.com/min/index.php?f=/styles/backstage/vst/gallery/v1/reset.css,/styles/backstage/vst/gallery/v1/flat.css,/styles/backstage/vst/gallery/v1/gallery-backstage/display.css">
	<!-- 新添加-->
    <link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/vst/gallery/v1/resources.css">
</head>
<body class="reManage mybody">
	<div class="main">
		<!-- 分销商tab  -->
		<ul class="reTab">
			<li id="trafficRuleTable" class="active">交通规则设置</li>
			<li id ="hotelRuleTable" value=${recommendId}>酒店规则设置</li>
		</ul>
		<!-- 交通规则设置  -->
		<div id="trafficRuleTabContent"><#include "/superfreetour/travelRecommendRule/travelRecommendTrafficRule.ftl"/> </div>
        <div id="hotelRuleTabContent"></div>
		
			
		<!-- 交通规则设置 END -->
		<!--酒店规则设置-->
		
	</div>
	<!--弹窗-->
	<div class="res-template">
		<!--选择航司 开始-->
		<div class="boat-change-box" style="display: none">
			<#--<label><input type="checkbox" boat-date="航司名称航司名称1">航司名称航司名称1</label>-->
			
            
		</div>
		<!--选择航司 END-->
		<!--选择日期组合时间段 开始-->
		<div class="date-change-box" style="display: none">
			<#--<label><input type="checkbox">D1</label>-->
		</div>
		<!--选择日期组合时间段 END-->
	</div>

<script src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/v1/common.js,/js/lv/dialog.js,/js/lv/calendar.js"></script>
<script src="http://pic.lvmama.com/min/index.php?f=/js/backstage/vst/gallery/v1/gallery-backstage/display.js"></script>
<!--新添加-->
<!--<script src="http://pic.lvmama.com/js/backstage/vst/gallery/v1/resources.js"></script>-->
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script>
	$(function () {
			//模拟旅游宝典ID
		//var recommendId=123456;
	    //必填项
        $(".js-require").each(function () {
            var $this = $(this);
            var $thisInput = $this.find("label input");
            var $require = $this.find(".require");
            var $thisCon =  $require.parents(".plane-choose-box").find(".require-con");
            $thisInput.on("click",function () {
                if($require.prop("checked") == true){
                    $thisCon.attr("disabled",false);
                }
                else if($require.prop("checked") == false){
                    $thisCon.attr("disabled",true);
                }
            })
        });
        //保存
        $(".save-traffic-btn").on("click",function () {
          var goStartMin= $("*[name='goStartMin']").val();
          var goStartMax= $("*[name='goStartMax']").val();
          var goArriveMin= $("*[name='goArriveMin']").val();
          var goArriveMax= $("*[name='goArriveMax']").val();
          var backStartMin= $("*[name='backStartMin']").val();
          var backStartMax= $("*[name='backStartMax']").val();
          if(goStartMin && goStartMax){
           if(Number(goStartMax.replace(":",""))<= Number(goStartMin.replace(":",""))){
            nova.dialog({
						content:"去程出发时间后者不能小于等于前者!",
						okCallback: true, 
					    okText: "确定",
					    okClassName:"btn-blue"
					    //time:2000 //定时关闭 
					});
           return;
           }
          }
          
          if(goArriveMin && goArriveMax){
            if(Number(goArriveMax.replace(":","")) <=Number(goArriveMin.replace(":",""))){
             nova.dialog({
						content:"去程到达时间后者不能小于等于前者!",
						okCallback: true, 
					    okText: "确定",
					    okClassName:"btn-blue"
					    //time:2000 //定时关闭 
					});
             return;
            }
          }
            
          if(backStartMin && backStartMax){
            if(Number(backStartMax.replace(":","")) <= Number(backStartMin.replace(":",""))){
              nova.dialog({
						content:"返程出发时间后者不能小于等于前者!",
						okCallback: true, 
					    okText: "确定",
					    okClassName:"btn-blue"
					    //time:2000 //定时关闭 
					});
             return;
            }
          }
            
            //提交表单
         submitForm();
        });
		
		   function submitForm(){
        	$.ajax({
				url : "/vst_admin/superfreetour/travelRecommendTrafficRule/updatetravelRecommendTrafficRule.do",
				type : "post",
				dataType : 'json',
				data : decodeURIComponent($('#travelRecommendTrafficRuleForm').serialize(),true),
				success : function(result) {
					if(result.code == "success"){
			         nova.dialog({
    				content: result.message,
    				okClassName:"btn-blue",
    				okCallback: function(){
        			//重新加载页面
        			window.location.reload();
    				}
					});
				   	} else {
						alert(result.message);
				 	}
				},
				error : function() {
					alert('网络服务异常, 请稍后重试');
				}
			});
        }
        
        $(".reTab li").on("click",function () {
		    var $this = $(this);
		    var $thisIndex = $this.index();
		    $this.addClass("active").siblings().removeClass("active");
		    /*if($thisIndex==0){
		     $('#trafficTable').show();
		     $('#hotelTable').hide();
		    }else if($thisIndex==1){
		    $('#trafficTable').hide();
		     $('#hotelTable').show();
		    }*/
		    //$(".js-tab-con").eq($thisIndex).show().siblings(".js-tab-con").hide();
		});
		
		var hotelFlag=0,trafficFlag=0;
		//切换交通规则设置
		$('#trafficRuleTable').die("click");
		$('#trafficRuleTable').live("click",function(){
		 $('#hotelRuleTabContent').hide().siblings('#trafficRuleTabContent').show();
		});
		
		//切换酒店规则设置
		$('#hotelRuleTable').die("click");
		$('#hotelRuleTable').live("click",function(){
			var $this = $(this);
			var recommendId=$this.val();
			//第一次点击 查询
			if(hotelFlag==0){
				hotelFlag=1;
				queryHotelRule(recommendId);
			}
			$('#trafficRuleTabContent').hide().siblings('#hotelRuleTabContent').show();
		
		});
		
		//查询酒店规则
		 function queryHotelRule(recommendId){
        	$.ajax({
				url : "/vst_admin/superfreetour/travelHotelRule/showHotelRule.do",
				type : "get",
				dataType : 'text',
				data : {recommendId:recommendId},
				success : function(data) {
				   $('#hotelRuleTabContent').html(data);
				},
				error : function() {
					alert('网络服务异常, 请稍后重试');
				}
			});
        }
	});

</script>

</body>
</html>