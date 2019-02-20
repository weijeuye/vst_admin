<!DOCTYPE html>
<html>
<head>
</head>
  <body>
  <style>
  	#dataDiv{
  	overflow-y: scroll;
   }
  </style>
  <form id="searchProdTagsForm">
	<input type="hidden" id="objectType" name="objectType" value=<#if prodTagVO.objectType??>${prodTagVO.objectType}</#if> />
	<input type="hidden" id="objectId" name="objectId" value=<#if prodTagVO.objectId??>${prodTagVO.objectId}</#if> />
	<input type="hidden" id="tagGroupId" name="tagGroupId" value=<#if prodTagVO.tagGroupId??>${prodTagVO.tagGroupId}</#if> />
	
	<div class="iframe-content"> 
		<table  border="0">
			 <tr>
				<td>
					<input type="radio" name="tagType" id="normalTag" value="1" checked /> 正常标签
				</td>
                
                <td style="padding-left: 30px">
                	<input type="radio" name="tagType" id="expiredTag" value="0" /> 过期标签
                </td>
                
                <td colspan="4">&nbsp;</td>            
	         </tr>
		</table>
		  
	    <div class="p_box" id="dataDiv">
		   
       </div>
   	</div>
   	</form>
   	<form id="saveDataForm">
	</form>
	
</body>
</html>

<script>

	function getUpdatedProdTags() {
		
		var dataDiv = $("#dataDiv");
		$.ajax({
			url : '/vst_admin/biz/prodTag/listUpdateProdTags.do',
			type : 'GET',
			data : $("#searchProdTagsForm").serialize(),
			success : function(res) {
			
				dataDiv.html("");
				dataDiv.html(res);
				dataDiv.parents('.dialog').height(dataDiv.height()+100);
				// $("#dataDiv").resizeWH();
			}
		});	
	}
	
	$(function() {
		
		getUpdatedProdTags();
		
		//操作标签类型  
		$("input[name='tagType']").bind("click",function() {  
 		       getUpdatedProdTags();
    	});  
	})
</script>