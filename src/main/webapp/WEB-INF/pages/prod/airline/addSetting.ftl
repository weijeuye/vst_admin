 <!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="/vst_admin/css/dialog.css" type="text/css"/>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/common.css"/>
<link rel="stylesheet" href="http://pic.lvmama.com/styles/backstage/v1/product-list.css"/>

<script type="text/javascript" src="http://pic.lvmama.com/js/new_v/jquery-1.7.min.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/common.js"></script>
<script src="http://pic.lvmama.com/js/backstage/v1/product-list.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<link rel="stylesheet" href="/vst_admin/css/jquery.jsonSuggest.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/jquery.ui.autocomplete.css" type="text/css"/>
<link rel="stylesheet" href="/vst_admin/css/jquery.ui.theme.css" type="text/css"/>
<script type="text/javascript" src="/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.lvtip.js"></script>
<script type="text/javascript" src="/vst_admin/js/iframe-custom.js"></script>
<script type="text/javascript" src="/vst_admin/js/pandora-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/lvmama-dialog.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.easyui.min-1.3.1.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.validate.expand.js"></script>
<script type="text/javascript" src="/vst_admin/js/messages_zh.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_validate.js"></script>
<script type="text/javascript" src="/vst_admin/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.lvtip.js"></script>
<script type="text/javascript" src="/vst_admin/js/newpanel.js"></script>
<script type="text/javascript" src="/vst_admin/js/jquery.jsonSuggest-2.min.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_pet_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/vst_util.js"></script>
<script type="text/javascript" src="/vst_admin/js/log.js"></script>

</head>
<body>
<input type="hidden" id="checkFlag" value="${checkFlag}">  
选择显示的航空公司：&nbsp;&nbsp;
<input type="checkbox"  autoValue="true" id="checkAll"/>全选/全不选 <br/>
<div style="margin-left: 120px">
<#assign tag=1>
<tr>
<#list airNameChecked as airLine>
<td width="20%"><input type="checkbox"  class="w35 textWidth" checked="checked" id="flight${tag}" value="${airLine.airCorpPriority.airCode}" /><span style="width:150px;display:inline-block"><span id="span${tag}" style="color:red;display:none">*</span>${airLine.airName!''}</span></td>
<td>
<select class="form-control" id="priority${tag}" style="width:110px;height:30px;">
<option value="0" >请选择优先级</option>
<#assign iSum=1>
<#list 1..9 as t>
<#if (airLine.airCorpPriority.priority==iSum)> 
<option value="${iSum}" selected="selected">优先级${iSum}</option>
<#assign iSum=iSum+1>
<#else>
<option value="${iSum}" >优先级${iSum}</option>
<#assign iSum=iSum+1>
</#if>
</#list>

<#if (airLine.airCorpPriority.priority=='A')>
<option value="10" selected="selected">优先级10</option>
<#else>
<option value="10">优先级10</option>
</#if>
</select>
</td>
<td>
<select class="form-control" id="tripFlag${tag}" style="width:110px;height:30px;">
<#switch "${airLine.airCorpPriority.tripFlag}">
<#case 'TOBACK'>
<option value="0">请选择往返程</option>
<option value="TO">去程</option>
<option value="BACK">返程</option>
<option value="TOBACK" selected="selected">往返程</option>
<#break>

<#case 'TO'>
<option value="0">请选择往返程</option>
<option value="TO" selected="selected">去程</option>
<option value="BACK">返程</option>
<option value="TOBACK">往返程</option>
<#break>
 
<#case 'BACK'>
<option value="0">请选择往返程</option> 
<option value="TO">去程</option>
<option value="BACK" selected="selected">返程</option>
<option value="TOBACK">往返程</option>
<#break>

<#default>
</#switch>
</select>
</td>
<#assign tag=tag+1>
</#list>

<#list airNameNotChecked as airLine>
<td ><input type="checkbox"  class="w35 textWidth" id="flight${tag}" value="${airLine.airCorpPriority.airCode}" /><span style="width:150px;display:inline-block"><span id="span${tag}" style="color:red;display:none">*</span>${airLine.airName!''}</span></td>
<td>
<select class="form-control" id="priority${tag}" style="width:110px;height:30px;background-color: #EEEEEE;" disabled="disabled">
<option value="0" selected="selected">请选择优先级</option>
<option value="1">优先级1</option>
<option value="2">优先级2</option>
<option value="3">优先级3</option>
<option value="4">优先级4</option>
<option value="5">优先级5</option>
<option value="6">优先级6</option>
<option value="7">优先级7</option>
<option value="8">优先级8</option>
<option value="9">优先级9</option>
<option value="10">优先级10</option>
</select>
</td>

<td>
<select class="form-control" id="tripFlag${tag}" style="width:110px;height:30px;background-color: #EEEEEE;" disabled="disabled">
<option value="0" selected="selected">请选择往返程</option>
<option value="TO">去程</option>
<option value="BACK">返程</option>
<option value="TOBACK">往返程</option>
</select>
</td>
<#assign tag=tag+1>
</#list>
</tr>

<input type="hidden" id="pdesProductId" value=${productId} /> 

</div>

<br/><br/>
<hr/>
<span style="color:red">* 多选时请务必选择优先级，优先级越高，在前台越靠前显示</span>
<br/>
<span style="color:red">* 保存后，前台页面将仅显示所选航司的航班</span>
<br/><br/>
<a class="btn btn-primary JS_btn_select" style="margin-left:450px" id="saveAirLine">保存</a>
</body>
</html>
<script>

	//保存方法tripFlag${tag}
	$("#saveAirLine").bind("click",function(){
		
		 var productId=$("#pdesProductId").val();
		 var arr=[];
		 var flag=0;
		 for(var i=1;i< ${tag} ;i++)
		{
		// var checked = document.getElementsByName("flight"+i);
			if($("#flight"+i).attr('checked'))
			{
			   flag=2;
			if($("#priority"+i+" option:selected").val()==0||$("#tripFlag"+i+" option:selected").val()==0)
			{
				flag=1;
				$("#span"+i).css('display','');
				continue;
			}
			if($("#priority"+i+" option:selected").val()!=0&&$("#tripFlag"+i+" option:selected").val()!=0)
			{
				$("#span"+i).css('display','none');
			}
			arr.push($("#flight"+i).val()+"*"+$("#priority"+i+" option:selected").val()+"*"+$("#tripFlag"+i+" option:selected").val());
			}
			else
			{
				$("#span"+i).css('display','none');
			}
		}
		 if(flag==1)
		{
		    alert("勾选中的航司 必须设置往返程和优先级");
		    return;
		}
		if(flag==0)
		{
			 alert("没有选择任何航司,请选择  取消限制  操作");
			 return;
		}
	 	$.get("/vst_admin/airlineQuery/addSave.do?arr="+arr+"&productId=" + productId ,
		function(){
	 		$.get("/vst_admin/airlineQuery/findCAirLine.do?productId=" + productId ,
	 		function(){
	 				 	window.parent.selectMethodDialog.close();
	 				  });
	 		});
	 	
	});
	
	//全选，全不选
	$("#checkAll").change("click",function(){
		
		if($("#checkAll").attr('checked')=='checked')
		{
		  for(var i=1;i< ${tag} ;i++)
		  {
			$("#flight"+i).attr("checked","checked");
		  }
		}
		else
		{
			for(var i=1;i< ${tag} ;i++)
			{
				$("#flight"+i).attr("checked",false);
			}
		}
	 	
	});
	
	$(document).ready(function(){
		if($("#checkFlag").val()==0)
		{
		   $("#checkAll").click();
		   for(var i=1;i< ${tag} ;i++)
			{
			  $('#priority'+ i).removeAttr("disabled");
			  $('#tripFlag'+ i).removeAttr("disabled");
			  $("#priority"+ i).css("background-color", "");
			  $("#tripFlag"+ i).css("background-color", "");
			}		   
		}
    });
	
	  
            $("input[type=checkbox]").click(function() {  
                    var checkbox_value = $(this).attr('id');
  					checkbox_value=checkbox_value.substring(6);
					if(checkbox_value=='ll')
					{
					  if ($("#checkAll").is(":checked")) 
						{  for(var i=1;i< ${tag} ;i++)
							{
							  $('#priority'+ i).removeAttr("disabled");
							  $('#tripFlag'+ i).removeAttr("disabled");
							  $("#priority"+ i).css("background-color", "");
							  $("#tripFlag"+ i).css("background-color", "");
							}
						 }
					  else{
						  for(var i=1;i< ${tag} ;i++)
							{
							  $('#priority'+ i).attr("disabled","disabled");
							  $('#tripFlag'+ i).attr("disabled","disabled");
							  $("#priority"+ i).css("background-color", "#EEEEEE");
							  $("#tripFlag"+ i).css("background-color", "#EEEEEE");
							}
						  
						 }
					}
					else
					{ 
						 if ($("#flight" + checkbox_value).is(":checked")) 
						 {  
							 $('#priority'+ checkbox_value).removeAttr("disabled");
							 $('#tripFlag'+ checkbox_value).removeAttr("disabled");
							 $("#priority"+ checkbox_value).css("background-color", "");
							 $("#tripFlag"+ checkbox_value).css("background-color", "");
					      } 
					      else
					      {
					    	  $('#priority'+ checkbox_value).attr("disabled","disabled");
							  $('#tripFlag'+ checkbox_value).attr("disabled","disabled");
							  $("#priority"+ checkbox_value).css("background-color", "#EEEEEE");
							  $("#tripFlag"+ checkbox_value).css("background-color", "#EEEEEE");
					      }
					}
            });  
		         
</script>
