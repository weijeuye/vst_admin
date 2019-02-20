<!DOCTYPE html>
<html>
<head>
</head>
  <body>
	<form id="dataForm">
		<table class="p_table form-inline">
			<tbody>
				<tr>
					<input type="hidden" id="tagId" name="tagId" value=<#if bizTag??>${bizTag.tagId}</#if>>
					<td class="p_label" width="100px;"><i class="cc1">*</i>小组名称：</td>
                	<td colspan=2>
                		<div>
	                		<select id="tagGroup" name="tagGroupId" required>
							  	<option value="">请选择</option>
							  	<#if tagGroups?? && tagGroups?size gt 0>
		                    		<#list tagGroups as tagGroup>
		                    			<option value="${tagGroup.tagGroupId}">
		                    				${tagGroup.tagGroupName}
		                    			</option>
		                    		</#list>
	                    		</#if>
		                	</select>
                	   </div>
                	</td>
				</tr>
				<tr>
					<td class="p_label"><i class="cc1">*</i>标签名称：</td>
					<td colspan=2>
                		<div>
                			<select id="tagName" name="tagName" required>
		                	</select>
		                	<input id="selectTagName" required style="display:none"/>
                	   </div>					
					</td>
				</tr>
			</tbody>
		</table>
		<div class="fl operate" style="margin:20px;width: 700px;" align="center">
			<input type="hidden" value="${prodTagVO.objectType}" name="objectType" id="objectType"/>
			<a class="btn btn_cc1" id="delete">删除</a>
			<a class="btn btn_cc1" id="cancel">取消</a>
		</div>		
	</form>
	
	<form id="deleteForm">
	</form>	
	
	<form id="saveDataForm">
	</form>	
</body>
</html>
	<script type="text/javascript" src="/vst_admin/js/loading.js"></script>
	<script>
		
	   function createItem(name,value){
     	   $("#deleteForm").append('<input type=hidden name='+name+' value='+value+'>');
	   }
	
		$(function(){
			// 删除
			$('#delete').bind('click',function(){
				//验证
				$("#selectTagName").show();
				if(!$("#dataForm").validate({
					rules : {
						tagGroupId:{
							required : true
						},
						tagName:{
							required : true
						}
					}
				}).form()){
					$("#selectTagName").hide();
					return false;
				}   
				$("#selectTagName").hide();
				// 清空表单
				$('#deleteForm').empty();				
				
				$("input[type=checkbox][name=objectIds]:checked").each(function(){
				 	 var value = $(this).val();
					 createItem('objectIds',value);
				});
				
				// 小组名称
				var tagGroupId = $('#tagGroup').val();
				createItem('tagGroupId',tagGroupId);
				
				var tagName = $('#selectTagName').val();
				createItem('tagName',tagName);
				
				// 对象类型
				var objectType = $('#objectType').val();
				createItem('objectType',objectType);				
				
				$.confirm('确定删除',function(){
					startLoading('正在删除，请稍候...');
					$.ajax({
						url : "/vst_admin/biz/prodTag/deleteProdTagByObject.do",
						type : "post",
						data : $("#deleteForm").serialize(),
						success : function(result) {
							completeLoading();
							if(result.code=='success'){
					 	 	 	 $.alert(result.message,function(){
					 	 	 	 	search();
					   				delDialog.close();	
					 	 	 	 });
					 	 	 }else{
					 	 	 	var errorMsg = JSON.parse(result);
								$.alert(errorMsg.message);		 	 	 
					 	 	 }
						}
					});				
				});
			});
			
			// 取消
			$('#cancel').bind('click',function(){
				delDialog.close();	
			});
			
			$('#tagGroup').bind('change',function(){
				$("#selectTagName").val('');
				findAllTagNameByGroup();
			});
			
			findAllTagNameByGroup();
		})
		
		// 根据小组名称查询标签
		function findTagNameByGroup(){
			var tagGroupId = $('#tagGroup').val();
			$('#saveDataForm').empty();
			$("#saveDataForm").append("<input type=\'hidden\' name=\'tagGroupId\' value=\'"+tagGroupId+"\'>");
			$.ajax({
				url : "/vst_admin/biz/bizTag/findTagNameByGroup.do",
				type : "post",
				async: false,
				data : $("#saveDataForm").serialize(),
				success : function(result) {
					$('#tagName').empty();
					$('#tagName').append("<option value=\'\'>请选择</option>");
					$.each(result,function(index,data){
						$('#tagName').append("<option value=\'"+data.tagName+"\'>"+data.tagName+"</option>");
					});
				},
				error : function(result) {
					$.alert(result.message);
				}
			});		
		}	
		
				// 根据小组名称查询有效标签
		function findAllTagNameByGroup(){
			$('#tagName').combobox({  
	            url : "/vst_admin/biz/bizTag/findAllTagNameByGroup.do?iniAll="+encodeURIComponent(encodeURIComponent('请选择'))+"&tagGroupId=" + $('#tagGroup').val(),
	            valueField:'tagValue',  
	            textField:'tagName',
	            filter: function(q, row){
	                var opts = $(this).combobox('options');
	                return row[opts.textField].match(q);
	            }, 
	            onLoadSuccess:function(){
	            	var tagName = $("#selectTagName").val();
	            	if(tagName != ''){
	            		$('#tagName').combobox('setValue',tagName).combobox('setText',tagName);
	            	}else{
	            		$('#tagName').combobox('setText','请选择');
	            	}
	            }, 
	            onLoadError:function(){
	            	$.alert(result.message);
	            },
	            onChange: function (n,o){
	            	if(n==''){
	            		$("i[for=selectTagName]").show();
	            	}else{
	            		$("i[for=selectTagName]").hide();
	            	}
	            	$("#selectTagName").val(n);
	            }       
	     	});
		}	
	</script>