<!DOCTYPE html>
<html>
<head>
<#include "/base/head_meta.ftl"/>
</head>
<body>	
<!-- 主要内容显示区域 -->
<div class="iframe-content">   
	<div class="p_box">
		<li class="cc3">提示：绑定预控项目后，不可在绑定页面进行修改，只能在买断资源预控系统中修改。请慎重选择！</li>
		<input type="hidden" id="goodsId" value="${goodsId}"/>
		<table class="p_table table_center">
			<thead>
			    <tr>
			        <th></th>
			        <th>预控名称</th>
			    	<th>游玩时间</th>
			    	<th>预控方式</th>
			    </tr>
			</thead>
			<tbody>
				<#if resPrecontrolList??>
			    	<#list resPrecontrolList as resPrecontrol>
						<tr>
							<td>
								<input type="checkbox" value="${resPrecontrol.id}" name="resPrecontrolId" />
							</td>
							<td>${resPrecontrol.name!''}</td>
							<td>${resPrecontrol.tradeEffectDate?string("yyyy-MM-dd")} - ${resPrecontrol.tradeExpiryDate?string("yyyy-MM-dd")}</td>
				            <td>${resPrecontrol.controlTypeCnName!''}</td>
						</tr>
			        </#list>
			    <#else>
			    	<tr><td colspan="4"><li class="cc3">未查询到存在新建或是启用状态的预控项目！</li></td></tr>
		        </#if>
			</tbody>
		</table>
	</div><!--p_box-->	
	<div align="center">
		<div class="fl operate" style="width:690px;margin:0 auto;"><a class="btn btn_cc1" id="saveButton">保存</a></div>
	</div>
</div><!-- //主要内容显示区域 -->
<#include "/base/foot.ftl"/>
</body>
</html>
<script>

$("#saveButton").bind("click",function(){
	//点击保存把数据传到父页面
	var resPrecontrolIdArray = new Array();
   	var resPrecontrolNameArray = new Array();
   	var idAndTime = new Array();
   	$("input[name='resPrecontrolId']:checked").each(function(){
    	resPrecontrolIdArray.push($(this).val());
       	resPrecontrolNameArray.push($(this).parent().next().text());
       	idAndTime.push($(this).parent().next().next().text());
   	});
   	if(resPrecontrolIdArray.length < 1){
   		alert("请绑定预控项目！");
	   	return;
   	}
   
   	if(idAndTime.length > 1){
	    for(var i = 0;i<idAndTime.length-1;i++){
        	for(var j=i+1;j<idAndTime.length;j++){
				var time1=idAndTime[i];
				var time2=idAndTime[j];
        		var result = validTimeRepeat(time1,time2);
        		if(result == false){
        			return;
        		}
        	}
        }
   	}
   	var goodsId = $("#goodsId").val();
   	var resPrecontrolIdString=resPrecontrolIdArray.join(',');
   	var resPrecontrolNameString=resPrecontrolNameArray.join(',');
   	var map={
 		"resPrecontrolIds":resPrecontrolIdString,
     	"resPrecontrolName":resPrecontrolNameString,
     	"goodsId" : goodsId
   	};
   	window.parent.preControlData(map);
   	window.parent.bindControlProjectDialog.close();
});

function validTimeRepeat(time1,time2){
        var arr1 = time1.split(' - ');
        var arr2 = time2.split(' - ');
        var beginTime1 = new Date(arr1[0]).getTime();
		var endTime1 = new Date(arr1[1]).getTime();
		var beginTime2 = new Date(arr2[0]).getTime();
		var endTime2 = new Date(arr2[1]).getTime();
		if(!(endTime2 < beginTime1 || endTime1 < beginTime2)){
		  	$.alert("复选的预控项目的游玩时间存在交集，不可同时绑定");
	    	return false;
		}
}

</script>