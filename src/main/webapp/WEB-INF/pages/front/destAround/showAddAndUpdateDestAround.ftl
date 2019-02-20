
<div class="iframe_content">
<div class="p_box box_info p_line">

<form id="destAdvertisingForm">
	  <input type="hidden" name="destId" value="${destId!''}">
	  <input type="hidden" name="destName" value="${destName!''}">
	  
	  <div class="box_content" style="width:1000;height:500px;overflow-y:auto;">
	  	<div><a class="btn btn_cc1" id="new_button">添加出发地</a></div>
	  	<br/>
        <table class="p_table table_center">
        	<thead>
                  <th>编号</th><th>第二目的地</th><th>操作</th>
          	</thead>
            <tbody id="tbody">
            <#if destAroundList?? && destAroundList?size gt 0>
                <#list destAroundList as bizDestAround>
	                <tr>
			            <td>${bizDestAround.seq}</td>
			            <td>
			            	<input type="text" name="aroundDest" class="w35" id="dest_${bizDestAround_index}" value="${bizDestAround.aroundDistrict.districtName}" data="${bizDestAround.aroundDistrict.districtId}" readonly = "readonly" required >
			            	<input type="hidden" name="bizDestAroundList[${bizDestAround_index}].aroundDestId" id="aroundDestId${bizDestAround_index}" value="${bizDestAround.aroundDestId}">
			            	<input type="hidden" name="bizDestAroundList[${bizDestAround_index}].destId" id="destId${bizDestAround_index}" value="${bizDestAround.destId}">
			            	<input type="hidden" class="seq" name="bizDestAroundList[${bizDestAround_index}].seq" value="${bizDestAround.seq}">
			           		<span class="INPUT_TYPE_CHECKBOX" style='padding-inline-start:15px'>
			           		<#list destAroundTypeList as list>
			           			<#if list.code == 'FOREIGNLINE'>
			           				<input type="checkbox" name="bizDestAroundList[${bizDestAround_index}].destAroundType" value="${list.code!''}"  <#if list.code==bizDestAround.destAroundType>checked="true"</#if>/>&nbsp;${list.cnName}
			           			</#if>
	                		</#list>
			           		</span>
			            </td>
			            <td>
			            <a class='btn btn_cc1' name='del_button' 
			            arounDestId=${bizDestAround.aroundDistrict.districtId}
			            destId=${dest.destId}
			            aroundDestName=${bizDestAround.aroundDistrict.districtName}
			            aroundId=${bizDestAround.aroundId}>删除</a>
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
var destSelectDialog;
var districts = ',';//子页面选择项对象数组
var count =0;
var markDistrict;
var markDistrictId;
var districtSelectDialog;
var aroundDestSize;
$(function(){
//编辑页加载时先累计已有的行政区ID
$("input[name='aroundDest']").each(function(){
	markDistrictId = $(this).next().attr("id");
 	if($('#'+ markDistrictId).attr("data")!=""){
 		if(districts == ","){
 			districts = $('#'+ markDistrictId).attr("data");
 		}else{
 			districts = districts + "," + $('#'+ markDistrictId).attr("data");
 		}
 	}
});
	aroundDestSize = $("input[name=aroundDest]").size();
});

//选择行政区返回方法
function onSelectDistrict(params){
	if(params!=null){
		var districtId = params.districtId;
		districts = "";
		for(var i = 0; i < 100; i++){
			if($("#aroundDestId"+i) != null){
				if(typeof($("#aroundDestId"+i).val()) != "undefined"){
					 districts = districts + ',' + $("#aroundDestId"+i).val();
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
		$("input[name=aroundDest]").removeAttr("disabled");
		$("#"+markDistrict).val(params.districtName);
		$("#"+markDistrictId).val(districtId);
	}
	districtSelectDialog.close();
}





//新建行政区
$("#new_button").bind("click",function(){
	var rows = $("input[name=aroundDest]").size();
	count = rows;
	var $tbody = $("#tbody");
	var num = count + 1;
	var str ="<tr><td>"+num+"</td><td><input type='text' class='w35' name='aroundDest' id='dest_"+count+"' readonly = 'readonly' required='true' /><input type='hidden' name='bizDestAroundList["+count+"].aroundDestId' id='aroundDestId"+count+"'/><input type='hidden' class='seq' name='bizDestAroundList["+count+"].seq'/>"+
						"<span class='INPUT_TYPE_CHECKBOX' style='padding-inline-start:15px'>"+
			           	"<input type='checkbox' name='bizDestAroundList["+count+"].destAroundType' value='FOREIGNLINE'/>&nbsp;出境</span>"+
			           	"</td><td><a class='btn btn_cc1' name='del_button'>删除</a></td></tr>";
	$tbody.append(str);
});



//删除行政区
$("a[name=del_button]").die("click").live("click",function(){
$(this).parents("tr").remove();
$("input[name=aroundDest]").each(function(i){
$(this).parents("tr").find("td:eq(0)").text(i+1);
$(this).parents("tr").find(".seq").val(i+1);
if(aroundDestSize>0 && ($("input[name='aroundDest']").size()==0)){
aroundDestSize = 0;
}
});
	
});


//打开选择行政区
$("input[name=aroundDest]").die("click").live("click",function(){
	markDistrict = $(this).attr("id");
	var idNum = markDistrict.split('_')[1];
	markDistrictId = 'aroundDestId'+idNum;
	var url = "/vst_admin/front/destAround/selectDistrictList.do?";
	districtSelectDialog = new xDialog(url,{},{title:"选择行政区",iframe:true,width:"900",height:"550"});
});


$("#saveButton").click(function(){
	var count=0;
  	$("input[name=aroundDest]").each(function(){
			if($(this).val()==""){
				$(this).parents("tr").remove();
			}else{
				count++;
			}
		})
	if(aroundDestSize==0 &&count<=0){
  		alert("改变后再保存");
  		return;
  	}
	$("input[name=aroundDest]").each(function(i){
			$(this).parents("tr").find("td:eq(0)").text(i+1);
			$(this).parents("tr").find(".seq").val(i+1);
		})
	var msg = '确认保存吗 ？';
	$.confirm(msg,function(){
		//遮罩层
		$("#saveButton").attr("disabled","disabled");
		$.ajax({
			url : "/vst_admin/front/destAround/addDestAround.do",
			type : "post",
			dataType : 'json',
			data : $("#destAdvertisingForm").serialize(),
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