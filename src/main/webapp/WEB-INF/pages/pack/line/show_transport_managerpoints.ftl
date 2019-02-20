<!DOCTYPE html>
<html>
<head>

<#include "/base/head_meta.ftl"/>
</head>
<body>
<div class="iframe_content mt10">

<input type="hidden" id = "groupType" name="groupType" value="TRANSPORT"/>
<input type="hidden" id = "productId" name="productId" value="${productId }"/>
<input type="hidden" id = "groupId" name="groupId" value="${groupId}" />
<#assign toBackFlag = packTransport.toDestination != null />

<form action="" method="post" id="dataForm">
			<div class="p_box box_info p_line" style="border:solid 1px #aaa">
	            <div >
					<#if trafficList ??>
						<#list trafficList as traffic> 
							<#if traffic ??>
									<#if toBackFlag>
										<#if traffic.checkedFlag?? && traffic.checkedFlag == 'Y'>
										<input type="checkbox" name="districtCheckBox"  value="${traffic.startDistrictObj.districtId}" checked="checked" />
										<#else>
										<input type="checkbox" name="districtCheckBox"  value="${traffic.startDistrictObj.districtId}" />
										</#if>
										<span style="width:110px;display:inline-block;">${traffic.startDistrictObj.districtName!''}</span>
									<#else>
										<#if traffic.checkedFlag?? && traffic.checkedFlag == 'Y'>
										<input type="checkbox" name="districtCheckBox"  value="${traffic.endDistrictObj.districtId}" checked="checked" />
										<#else>
										<input type="checkbox" name="districtCheckBox"  value="${traffic.endDistrictObj.districtId}" />
										</#if>
										<span style="width:110px;display:inline-block;">${traffic.endDistrictObj.districtName!''}</span>
									</#if>
									<#if (traffic_index+1)%5 == 0></br></#if>
							</#if>
						</#list>
					  </#if>
	            </div>
	            </br>
	            <table style="width: 500px">
	            <tr>
	            	<td class=" operate mt10" asign="left"><a class="btn btn_cc1" id="saveDistrict">保存</a></td>
	            	<td class=" operate mt10" asign="right"><a class="btn btn_cc1" id="cancel">取消</a></td>
	            </tr>
	            </table>
	            </br>
	        </div>
</form>
<#include "/base/foot.ftl"/>
</body>
</html>
<script>
$(function(){
	$("#cancel").bind("click",function(){
	window.parent.openManagerPointsDialog.close();
	});

	$("#saveDistrict").bind("click",function(){
		var checkValues =[]; 
		var uncheckValues =[]; 
		$('input[name="districtCheckBox"]:checked').each(function(){ 
			checkValues.push($(this).val()); 
		});
		$('input[name="districtCheckBox"]:unchecked').each(function(){ 
			uncheckValues.push($(this).val()); 
		});
		if(checkValues.length == 0){
			$.confirm("全不选状态下，将删除该行程下交通信息，是否确认删除？",function(){
				saveautoPackDistrictPoint(checkValues.toString(),uncheckValues.toString());
			});
		}else{
			saveautoPackDistrictPoint(checkValues.toString(),uncheckValues.toString());
		}
	});
});



	function saveautoPackDistrictPoint(checkValuesStr,uncheckValuesStr){
		var productId = $("#productId").val();
		var groupId = $("#groupId").val();
		if(!checkValuesStr){checkValuesStr = "";}
		if(!uncheckValuesStr){uncheckValuesStr = "";}
		$.ajax({
		  url : "/vst_admin/productPack/line/saveautoPackDistrictPoint.do",
		  type : "post",
		  dataType : 'json',
		  async: false,
		  data : "productId="+productId+"&groupId="+groupId+"&checkValuesStr="+checkValuesStr+"&uncheckValuesStr="+uncheckValuesStr,
		  success : function(result) {
		  		if(!result||result.code!="success"){
		  			alert("保存失败！");
		  		}else{
			   		alert("保存成功！");
			   		parent.onOpenManagerPoints();
		  		}
			},
			error : function(result) {
				$.alert(result.message);
			}
		});
	}

</script>