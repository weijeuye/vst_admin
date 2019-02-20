
<div class="iframe_content">
<div class="p_box">

<form id="districtAdvertisingForm">
	  <input type="hidden" name="districtId" value="${districtId!''}">
	  <input type="hidden" name="districtName" value="${districtName!''}">
	  
	  <div class="box_content" style="width:1000;height:500px;overflow-y:auto;">
	  	<div><a class="btn btn_cc1" id="new_button">添加出发地</a></div>
	  	<br/>
        <table class="p_table table_center">
        	<thead>
                  <th>编号</th><th>第二出发地</th><th>排序值</th><th>操作</th>
          	</thead>
            <tbody id="tbody">
            <#if districtAroundList?? && districtAroundList?size gt 0>
                <#list districtAroundList as bizDistrictAround>
	                <tr>
			            <td>${bizDistrictAround_index+1}</td>
			            <td>
			            	<input type="text" name="aroundDistrict" class="w35" id="district_${bizDistrictAround_index}" value="${bizDistrictAround.aroundDistrict.districtName}" data="${bizDistrictAround.aroundDistrict.districtId}" readonly = "readonly" required >
			            	<input type="hidden" name="bizDistrictAroundList[${bizDistrictAround_index}].aroundDistrictId" id="aroundDistrictId${bizDistrictAround_index}" value="${bizDistrictAround.aroundDistrictId}">
			            	<input type="hidden" name="bizDistrictAroundList[${bizDistrictAround_index}].districtId" id="districtId${bizDistrictAround_index}" value="${bizDistrictAround.districtId}">
			            	<span class="INPUT_TYPE_CHECKBOX" style='padding-inline-start:15px'>
			           		<#list districtAroundTypeList as list>
			           			<#if list.code == 'FOREIGNLINE'>
			           				<input type="checkbox" name="bizDistrictAroundList[${bizDistrictAround_index}].districtAroundType" value="${list.code!''}"  <#if list.code==bizDistrictAround.districtAroundType>checked="true"</#if>/>&nbsp;${list.cnName}
			           			</#if>
	                		</#list>
			           		</span>
			            </td>
			            <td>
			            	<input type="text" style='width:50px' class="seq" name="bizDistrictAroundList[${bizDistrictAround_index}].seq" value="${bizDistrictAround.seq!1}">
			            </td>
			            <td>
			            <a class='btn btn_cc1' name='del_button' 
			            aroundDistrictId=${bizDistrictAround.aroundDistrict.districtId}
			            aroundDistrictName=${bizDistrictAround.aroundDistrict.districtName}
			            aroundId=${bizDistrictAround.aroundId}>删除</a>
			            </td>
	        	    </tr>
            	</#list>
        	</#if>
        	</tbody>
        </table>
    </div>
		
</form>
<button class="pbtn pbtn-small btn-ok" style="float:right;margin-top:20px;" id="saveButton" name="saveButton">保存</button>

</div>
</div><!-- //主要内容显示区域 -->

<script>
var DistrictSelectDialog;
var districts = ',';//子页面选择项对象数组
var count =0;
var markDistrict;
var markDistrictId;
var districtID;
var aroundDistrictSize; 
$(function(){
aroundDistrictSize = $("input[name=aroundDistrict]").size();



});


//编辑页加载时先累计已有的行政区ID
$("input[name='aroundDistrict']").each(function(){
	markDistrictId = $(this).next().attr("id");
 	if($('#'+ markDistrictId).attr("data")!=""){
 		if(districts == ","){
 			districts = $('#'+ markDistrictId).attr("data");
 		}else{
 			districts = districts + "," + $('#'+ markDistrictId).attr("data");
 		}
 	}
});

var districtSelectDialog;
//选择行政区返回方法
function onSelectDistrict(params){
	if(params!=null){
		var districtId = params.districtId;
		districts = "";
		for(var i = 0; i < 80; i++){
			if($("#aroundDistrictId"+i) != null){
				if(typeof($("#aroundDistrictId"+i).val()) != "undefined"){
					 districts = districts + ',' + $("#aroundDistrictId"+i).val();
				}
			}
		}
		if((districts+',').indexOf(','+districtId+',')==0 || (districts+',').indexOf(','+districtId+',')> 0 )
		{
		    alert('行政区已经存在');
		    return;
		}else{
			districts = districts + ',' + districtId;
		}
		$("input[name=aroundDistrict]").removeAttr("disabled");
		$("#"+markDistrict).val(params.districtName);
		$("#"+markDistrictId).val(districtId);
	}
	districtSelectDialog.close();
}

//新建行政区
$("#new_button").bind("click",function(){
	var rows = $("input[name=aroundDistrict]").size();
	count = rows;
	var $tbody = $("#tbody");
	var num = count + 1;
	$tbody.append("<tr><td>"+num+"</td><td><input type='text' class='w35' name='aroundDistrict' id='district_"+count+"' readonly = 'readonly' required='true' /><input type='hidden' name='bizDistrictAroundList["+count+"].aroundDistrictId' id='aroundDistrictId"+count+"'/>"+
	"<span class='INPUT_TYPE_CHECKBOX' style='padding-inline-start:20px'>"+
	"<input type='checkbox' name='bizDistrictAroundList["+count+"].districtAroundType' value='FOREIGNLINE'/>&nbsp;出境</span>"+
	"</td><td><input type='text' style='width:50px' class='seq' name='bizDistrictAroundList["+count+"].seq' value='1'></td><td><a class='btn btn_cc1' name='del_button'>删除</a></td></tr>"); 
});

//删除行政区
$("a[name=del_button]").die("click").live("click",function(){

$(this).parents("tr").remove();
$("input[name=aroundDistrict]").each(function(i){
$(this).parents("tr").find("td:eq(0)").text(i+1);
if(aroundDistrictSize>0 && ($("input[name='aroundDistrict']").size()==0)){
aroundDistrictSize = 0;
}
});
	
});

//打开选择行政区
$("input[name=aroundDistrict]").die("click").live("click",function(){
	markDistrict = $(this).attr("id");
	var idNum = markDistrict.split('_')[1];
	markDistrictId = 'aroundDistrictId'+idNum;
	districtID = $("input[name = 'districtId']").val();
	var url = "/vst_admin/front/districtAround/selectDistrictList.do?";
	districtSelectDialog = new xDialog(url,{},{title:"选择行政区",iframe:true,width:"900",height:"550"});
});



$("#saveButton").click(function(){
  	var count=0;
  	var seqFlag=false;
  	$("input[name=aroundDistrict]").each(function(){
			if($(this).val()==""){
				$(this).parents("tr").remove();
			}else{
				count++;
			}
		})
	if(aroundDistrictSize==0 &&count<=0){
  		alert("改变后再保存");
  		return;
  	}
	$("input[name=aroundDistrict]").each(function(i){
			$(this).parents("tr").find("td:eq(0)").text(i+1);
			var seqValue=$(this).parents("tr").find(".seq").val();
			if(isNaN(seqValue)||seqValue<1||seqValue>99||$.trim(seqValue)==""){
				seqFlag=true;
				return;
			}
			var r = /^\d+$/;
			if(!r.test(seqValue)){
				seqFlag=true;
				return;
			}
	})
	if(seqFlag){
		alert("排序值必须填写1-99之间的整数");
		return;
	}
	var msg = '确认保存吗 ？';
	$.confirm(msg,function(){
		//遮罩层
		$("#saveButton").attr("disabled","disabled");
		$.ajax({
			url : "/vst_admin/front/districtAround/addDistrictAround.do",
			type : "post",
			dataType : 'json',
			data : $("#districtAdvertisingForm").serialize(),
			success : function(result) {
				if(result.code == "success"){
					pandora.dialog({wrapClass: "dialog-mini", content:result.message, okValue:"确定",mask:true,ok:function(){
						$("#saveButton").removeAttr("disabled");
						addAndUpdateDialog.close();
					}});
				}else {
					$.alert(result.message);
					$("#saveButton").removeAttr("disabled");
				}
			},
			error : function(){
				$("#saveButton").removeAttr("disabled");
			}
		  });
	});
});

</script>